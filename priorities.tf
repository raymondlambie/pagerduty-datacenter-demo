# Priority Data Sources
# Reference existing priorities in PagerDuty account

data "pagerduty_priority" "p1_critical" {
  name = "P1"
}

data "pagerduty_priority" "p2_high" {
  name = "P2"
}

data "pagerduty_priority" "p3_low" {
  name = "P3"
}

data "pagerduty_priority" "p4_low" {
  name = "P4"
}
