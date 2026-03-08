#!/usr/bin/env python3
"""
PagerDuty Datacenter BMS Demo - Event Generator
Sends realistic Building Management System alerts to PagerDuty services
"""

import requests
import json
import time
import random
from datetime import datetime

# PagerDuty Events API v2 endpoint
EVENTS_API_URL = "https://events.pagerduty.com/v2/enqueue"

# Integration keys - CONFIGURED
INTEGRATION_KEYS = {
    "environmental_monitoring": "a0a2a03463144902d08920e53a47740c",
    "fire_safety": "c5d00f9ea61a4b03c07ed62a21622790",
    "hvac_cooling": "63f81c7b1ca84007d0b0b0c6f49dcee4",
    "network_infrastructure": "637565ba0ed34a00c0bf48cf227956bb",
    "physical_security": "6b35bd392cf04709d0776ab82dd5b7dc",
    "power_electrical": "1dc05c3ad2524005c06f79eff03e87cf"
}

# Demo scenarios
DEMO_SCENARIOS = {
    "environmental_critical_temp": {
        "service": "environmental_monitoring",
        "summary": "Critical Temperature Alert - Server Room A",
        "severity": "critical",
        "source": "TEMP-SENSOR-ROOM-A-01",
        "component": "Temperature Monitoring",
        "custom_details": {
            "component": "Temperature",
            "current_temp": "32°C",
            "threshold": "28°C",
            "location": "Server Room A",
            "sensor_id": "TEMP-A-01",
            "alert_type": "environmental_critical"
        }
    },
    "environmental_water_leak": {
        "service": "environmental_monitoring",
        "summary": "Water Leak Detected - Data Hall 2",
        "severity": "error",
        "source": "WATER-SENSOR-HALL-2-03",
        "component": "Water Detection",
        "custom_details": {
            "component": "Water Leak",
            "location": "Data Hall 2, Row 5",
            "sensor_id": "WATER-HALL-2-03",
            "alert_type": "environmental_critical"
        }
    },
    "environmental_humidity": {
        "service": "environmental_monitoring",
        "summary": "High Humidity Alert - Server Room B",
        "severity": "warning",
        "source": "HUMIDITY-SENSOR-ROOM-B-02",
        "component": "Humidity Monitoring",
        "custom_details": {
            "component": "Humidity",
            "current_humidity": "75%",
            "threshold": "60%",
            "location": "Server Room B",
            "sensor_id": "HUMIDITY-B-02"
        }
    },
    "fire_smoke_detected": {
        "service": "fire_safety",
        "summary": "CRITICAL: Smoke Detected - Data Hall 1",
        "severity": "critical",
        "source": "SMOKE-DETECTOR-HALL-1-05",
        "component": "Fire Detection",
        "custom_details": {
            "detector_id": "SMOKE-HALL-1-05",
            "location": "Data Hall 1, Row 8",
            "detector_type": "Aspirating Smoke Detection",
            "alarm_level": "Alert Level 2"
        }
    },
    "fire_suppression_activated": {
        "service": "fire_safety",
        "summary": "CRITICAL: Fire Suppression System Activated",
        "severity": "critical",
        "source": "SUPPRESSION-SYSTEM-HALL-2",
        "component": "Fire Suppression",
        "custom_details": {
            "system_id": "SUPPRESSION-HALL-2",
            "location": "Data Hall 2",
            "suppression_type": "FM-200 Gas",
            "discharge_status": "Active"
        }
    },
    "fire_alarm_test": {
        "service": "fire_safety",
        "summary": "[TEST] Fire Alarm System Test",
        "severity": "info",
        "source": "FIRE-PANEL-MAIN",
        "component": "Fire Alarm",
        "custom_details": {
            "test_type": "Monthly System Test",
            "scheduled_by": "Facilities Team",
            "duration": "15 minutes"
        }
    },
    "hvac_critical_failure": {
        "service": "hvac_cooling",
        "summary": "CRITICAL: HVAC Unit Failure - Data Hall 1",
        "severity": "critical",
        "source": "HVAC-HALL-1-UNIT-03",
        "component": "HVAC System",
        "custom_details": {
            "unit_id": "HVAC-HALL-1-03",
            "location": "Data Hall 1",
            "failure_type": "Compressor Failure",
            "estimated_temp_rise": "2°C per 10 minutes"
        }
    },
    "hvac_crac_failure": {
        "service": "hvac_cooling",
        "summary": "CRAC Unit Offline - Server Room A",
        "severity": "critical",
        "source": "CRAC-ROOM-A-02",
        "component": "CRAC Unit",
        "custom_details": {
            "unit_id": "CRAC-A-02",
            "location": "Server Room A",
            "failure_type": "Unit Offline",
            "backup_status": "Active"
        }
    },
    "hvac_chiller_alert": {
        "service": "hvac_cooling",
        "summary": "Chiller Low Efficiency - Building Chiller 1",
        "severity": "warning",
        "source": "Chiller-BLDG-01",
        "component": "Chiller System",
        "custom_details": {
            "unit_id": "Chiller-BLDG-01",
            "efficiency": "72%",
            "normal_efficiency": "85%",
            "action_required": "Schedule maintenance"
        }
    },
    "network_core_failure": {
        "service": "network_infrastructure",
        "summary": "CRITICAL: Core Switch Failure - Building Core",
        "severity": "critical",
        "source": "SWITCH-CORE-BLDG-01",
        "component": "Core Network",
        "custom_details": {
            "device_location": "SWITCH-CORE-BLDG-01",
            "impact_level": "high_impact_core_network",
            "affected_systems": "All data halls",
            "redundancy_status": "Failover active"
        }
    },
    "network_switch_down": {
        "service": "network_infrastructure",
        "summary": "Network Switch Down - Data Hall 2 Row 3",
        "severity": "error",
        "source": "SWITCH-HALL-2-ROW-3-05",
        "component": "Access Switch",
        "custom_details": {
            "device_location": "SWITCH-HALL-2-ROW-3-05",
            "affected_racks": "Racks 15-20",
            "customer_impact": "6 customers affected"
        }
    },
    "network_access_switch": {
        "service": "network_infrastructure",
        "summary": "Access Switch Port Errors - Hall 1",
        "severity": "warning",
        "source": "SWITCH-ACCESS-HALL-1-08",
        "component": "Access Switch",
        "custom_details": {
            "device_location": "SWITCH-ACCESS-HALL-1-08",
            "port": "GigabitEthernet 1/0/24",
            "error_rate": "High CRC errors"
        }
    },
    "security_door_breach": {
        "service": "physical_security",
        "summary": "SECURITY: Unauthorized Door Access - Data Hall 1",
        "severity": "critical",
        "source": "DOOR-SENSOR-HALL-1-MAIN",
        "component": "Access Control",
        "custom_details": {
            "location": "Data Hall 1 - Main Entrance",
            "access_method": "Forced entry detected",
            "camera_id": "CAM-HALL-1-03"
        }
    },
    "security_badge_fail": {
        "service": "physical_security",
        "summary": "Multiple Failed Badge Attempts - Server Room A",
        "severity": "error",
        "source": "BADGE-READER-ROOM-A-01",
        "component": "Access Control",
        "custom_details": {
            "location": "Server Room A",
            "attempts": "5 failed attempts",
            "badge_id": "Unknown"
        }
    },
    "power_ups_battery": {
        "service": "power_electrical",
        "summary": "CRITICAL: UPS On Battery - Data Hall 1",
        "severity": "critical",
        "source": "UPS-HALL-1-PRIMARY",
        "component": "UPS System",
        "custom_details": {
            "ups_id": "UPS-HALL-1-PRIMARY",
            "battery_runtime": "45 minutes remaining",
            "load": "85%",
            "mains_status": "Failed"
        }
    },
    "power_pdu_overload": {
        "service": "power_electrical",
        "summary": "PDU Overload Warning - Rack 42",
        "severity": "warning",
        "source": "PDU-HALL-2-RACK-42-A",
        "component": "PDU",
        "custom_details": {
            "pdu_id": "PDU-HALL-2-RACK-42-A",
            "current_load": "92%",
            "threshold": "80%",
            "action": "Load balancing required"
        }
    }
}


def send_event(scenario_name, scenario):
    """Send a PagerDuty event"""

    integration_key = INTEGRATION_KEYS.get(scenario["service"])

    if not integration_key or integration_key.startswith("YOUR_"):
        print(f"❌ Integration key not configured for {scenario['service']}")
        print(f"   Run: terraform output -json service_integration_keys")
        return False

    payload = {
        "routing_key": integration_key,
        "event_action": "trigger",
        "dedup_key": f"{scenario['source']}-{int(time.time())}",
        "payload": {
            "summary": scenario["summary"],
            "severity": scenario["severity"],
            "source": scenario["source"],
            "component": scenario["component"],
            "custom_details": scenario["custom_details"]
        }
    }

    try:
        response = requests.post(EVENTS_API_URL, json=payload, timeout=10)

        if response.status_code == 202:
            print(f"✅ {scenario_name}")
            print(f"   Service: {scenario['service']}")
            print(f"   Summary: {scenario['summary']}")
            print(f"   Severity: {scenario['severity']}")
            return True
        else:
            print(f"❌ Failed: {scenario_name}")
            print(f"   Status: {response.status_code}")
            print(f"   Response: {response.text}")
            return False

    except Exception as e:
        print(f"❌ Error sending {scenario_name}: {str(e)}")
        return False


def demo_sequence_1():
    """Demo Sequence 1: Environmental Emergency"""
    print("\n" + "="*60)
    print("DEMO SEQUENCE 1: Environmental Emergency")
    print("="*60)

    scenarios = [
        "environmental_critical_temp",
        "hvac_critical_failure",
        "environmental_water_leak"
    ]

    for scenario_name in scenarios:
        send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
        time.sleep(2)


def demo_sequence_2():
    """Demo Sequence 2: Network Infrastructure Failure"""
    print("\n" + "="*60)
    print("DEMO SEQUENCE 2: Network Infrastructure Failure")
    print("="*60)

    scenarios = [
        "network_core_failure",
        "network_switch_down"
    ]

    for scenario_name in scenarios:
        send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
        time.sleep(2)


def demo_sequence_3():
    """Demo Sequence 3: Security Incident"""
    print("\n" + "="*60)
    print("DEMO SEQUENCE 3: Security Incident")
    print("="*60)

    scenarios = [
        "security_door_breach",
        "security_badge_fail"
    ]

    for scenario_name in scenarios:
        send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
        time.sleep(2)


def demo_sequence_4():
    """Demo Sequence 4: Power Emergency"""
    print("\n" + "="*60)
    print("DEMO SEQUENCE 4: Power Emergency")
    print("="*60)

    scenarios = [
        "power_ups_battery",
        "power_pdu_overload"
    ]

    for scenario_name in scenarios:
        send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
        time.sleep(2)


def demo_sequence_5():
    """Demo Sequence 5: Fire Safety Emergency"""
    print("\n" + "="*60)
    print("DEMO SEQUENCE 5: Fire Safety Emergency")
    print("="*60)

    scenarios = [
        "fire_smoke_detected",
        "fire_suppression_activated"
    ]

    for scenario_name in scenarios:
        send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
        time.sleep(2)


def demo_all_scenarios():
    """Send all demo scenarios"""
    print("\n" + "="*60)
    print("DEMO: All Scenarios")
    print("="*60)

    for scenario_name, scenario in DEMO_SCENARIOS.items():
        send_event(scenario_name, scenario)
        time.sleep(1)


def interactive_menu():
    """Interactive demo menu"""
    while True:
        print("\n" + "="*60)
        print("PagerDuty Datacenter BMS Demo - Event Generator")
        print("="*60)
        print("\n1. Demo Sequence 1: Environmental Emergency")
        print("2. Demo Sequence 2: Network Infrastructure Failure")
        print("3. Demo Sequence 3: Security Incident")
        print("4. Demo Sequence 4: Power Emergency")
        print("5. Demo Sequence 5: Fire Safety Emergency")
        print("6. Send All Scenarios")
        print("7. Send Single Scenario")
        print("8. Test Integration Keys")
        print("0. Exit")

        choice = input("\nSelect option: ").strip()

        if choice == "1":
            demo_sequence_1()
        elif choice == "2":
            demo_sequence_2()
        elif choice == "3":
            demo_sequence_3()
        elif choice == "4":
            demo_sequence_4()
        elif choice == "5":
            demo_sequence_5()
        elif choice == "6":
            demo_all_scenarios()
        elif choice == "7":
            print("\nAvailable scenarios:")
            for i, name in enumerate(DEMO_SCENARIOS.keys(), 1):
                print(f"{i}. {name}")
            scenario_choice = input("\nSelect scenario number: ").strip()
            try:
                scenario_name = list(DEMO_SCENARIOS.keys())[int(scenario_choice) - 1]
                send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
            except (ValueError, IndexError):
                print("❌ Invalid selection")
        elif choice == "8":
            test_integration_keys()
        elif choice == "0":
            print("\n👋 Goodbye!")
            break
        else:
            print("❌ Invalid option")


def test_integration_keys():
    """Test if integration keys are configured"""
    print("\n" + "="*60)
    print("Testing Integration Keys")
    print("="*60)

    all_configured = True
    for service, key in INTEGRATION_KEYS.items():
        if key.startswith("YOUR_"):
            print(f"❌ {service}: NOT CONFIGURED")
            all_configured = False
        else:
            print(f"✅ {service}: Configured ({key[:8]}...)")

    if all_configured:
        print("\n✅ All integration keys are configured!")
        print("   Ready to send demo events!")


if __name__ == "__main__":
    print("\n🚀 PagerDuty Datacenter BMS Demo - Event Generator")
    print("   Timezone: Australia/Sydney")
    print("   Events API: v2")
    print("   Services: 6 (Environmental, Fire Safety, HVAC, Network, Security, Power)")

    # Test integration keys first
    test_integration_keys()

    # Start interactive menu
    interactive_menu()
