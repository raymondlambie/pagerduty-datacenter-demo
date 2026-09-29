#!/usr/bin/env python3
"""
Tally PagerDuty alert-level volume per service, for services routed to by a
Global Event Orchestration.

Usage:
    export PD_API_TOKEN=your_rest_api_v2_token
    python pagerduty_alert_volume_by_service.py \
        --orchestration-id GLOBAL_ORCH_ID \
        --since 2026-04-01 --until 2026-07-01 \
        --csv-out alert_volume_by_service.csv

Notes:
    - Volume is derived from each incident's `alert_counts.all` field, summed
      per service. This captures alerts that were grouped/deduped into
      incidents. It will NOT capture alerts that a service orchestration
      dropped/suppressed before they ever became part of an incident -- there
      is no public API for that raw "events matched" number (only visible in
      the orchestration's UI analytics tab). If any of the 84 service
      orchestrations use drop actions, this will undercount true ingestion.
"""
import argparse
import csv
import os
import sys
import time
from datetime import datetime

import requests

API_HOST_DEFAULT = "https://api.pagerduty.com"
PAGE_LIMIT = 100
SERVICE_BATCH_SIZE = 50  # keep query strings reasonably sized


def build_session(token: str) -> requests.Session:
    session = requests.Session()
    session.headers.update({
        "Authorization": f"Token token={token}",
        "Accept": "application/vnd.pagerduty+json;version=2",
    })
    return session


def request_with_retry(session: requests.Session, method: str, url: str, **kwargs) -> requests.Response:
    while True:
        resp = session.request(method, url, **kwargs)
        if resp.status_code == 429:
            retry_after = int(resp.headers.get("Retry-After", "5"))
            print(f"  rate limited, sleeping {retry_after}s...", file=sys.stderr)
            time.sleep(retry_after)
            continue
        resp.raise_for_status()
        return resp


def get_router_service_ids(session: requests.Session, api_host: str, orchestration_id: str) -> set:
    url = f"{api_host}/event_orchestrations/{orchestration_id}/router"
    resp = request_with_retry(session, "GET", url)
    path = resp.json()["orchestration_path"]

    service_ids = set()
    for rule_set in path.get("sets", []):
        for rule in rule_set.get("rules", []):
            route_to = rule.get("actions", {}).get("route_to")
            if route_to and route_to != "unrouted":
                service_ids.add(route_to)

    catch_all_route = path.get("catch_all", {}).get("actions", {}).get("route_to")
    if catch_all_route and catch_all_route != "unrouted":
        service_ids.add(catch_all_route)

    return service_ids


def get_service_names(session: requests.Session, api_host: str, service_ids: list) -> dict:
    names = {}
    for service_id in service_ids:
        url = f"{api_host}/services/{service_id}"
        resp = request_with_retry(session, "GET", url)
        names[service_id] = resp.json()["service"]["name"]
    return names


def chunked(items, size):
    items = list(items)
    for i in range(0, len(items), size):
        yield items[i:i + size]


def tally_alert_volume(session: requests.Session, api_host: str, service_ids: list,
                        since: str, until: str) -> dict:
    alert_counts = {sid: 0 for sid in service_ids}
    incident_counts = {sid: 0 for sid in service_ids}

    for batch in chunked(service_ids, SERVICE_BATCH_SIZE):
        offset = 0
        while True:
            params = [
                ("since", since),
                ("until", until),
                ("date_range", "all"),
                ("limit", PAGE_LIMIT),
                ("offset", offset),
                ("statuses[]", "triggered"),
                ("statuses[]", "acknowledged"),
                ("statuses[]", "resolved"),
            ]
            for sid in batch:
                params.append(("service_ids[]", sid))

            url = f"{api_host}/incidents"
            resp = request_with_retry(session, "GET", url, params=params)
            data = resp.json()

            for incident in data.get("incidents", []):
                sid = incident["service"]["id"]
                alert_counts[sid] += incident.get("alert_counts", {}).get("all", 0)
                incident_counts[sid] += 1

            if not data.get("more"):
                break
            offset += PAGE_LIMIT

    return alert_counts, incident_counts


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--orchestration-id", required=True, help="Global Event Orchestration ID")
    parser.add_argument("--since", required=True, help="Start date/time (ISO 8601, e.g. 2026-04-01)")
    parser.add_argument("--until", required=True, help="End date/time (ISO 8601, e.g. 2026-07-01)")
    parser.add_argument("--api-host", default=os.environ.get("PD_API_HOST", API_HOST_DEFAULT),
                         help="PagerDuty API host (use https://api.eu.pagerduty.com for EU accounts)")
    parser.add_argument("--csv-out", default="alert_volume_by_service.csv", help="Path to write CSV output")
    args = parser.parse_args()

    token = os.environ.get("PD_API_TOKEN")
    if not token:
        print("ERROR: set PD_API_TOKEN in your environment (a REST API v2 token).", file=sys.stderr)
        sys.exit(1)

    session = build_session(token)

    print(f"Fetching router rules for global orchestration {args.orchestration_id}...")
    service_ids = get_router_service_ids(session, args.api_host, args.orchestration_id)
    print(f"Found {len(service_ids)} distinct target services.")

    print("Resolving service names...")
    names = get_service_names(session, args.api_host, sorted(service_ids))

    print(f"Tallying alert volume from {args.since} to {args.until}...")
    alert_counts, incident_counts = tally_alert_volume(
        session, args.api_host, sorted(service_ids), args.since, args.until
    )

    rows = sorted(
        (
            {
                "service_id": sid,
                "service_name": names.get(sid, sid),
                "alert_count": alert_counts[sid],
                "incident_count": incident_counts[sid],
            }
            for sid in service_ids
        ),
        key=lambda r: r["alert_count"],
        reverse=True,
    )

    total_alerts = sum(r["alert_count"] for r in rows)

    name_width = max((len(r["service_name"]) for r in rows), default=20)
    print(f"\n{'Service':<{name_width}}  {'Alerts':>10}  {'Incidents':>10}")
    print("-" * (name_width + 24))
    for r in rows:
        print(f"{r['service_name']:<{name_width}}  {r['alert_count']:>10}  {r['incident_count']:>10}")
    print("-" * (name_width + 24))
    print(f"{'TOTAL':<{name_width}}  {total_alerts:>10}")

    with open(args.csv_out, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["service_id", "service_name", "alert_count", "incident_count"])
        writer.writeheader()
        writer.writerows(rows)

    print(f"\nWrote {args.csv_out}")


if __name__ == "__main__":
    main()
