# PagerDuty Priorities for Niagara BMS Alerts
# Priorities are account-level resources - we reference existing ones

# Get existing priorities from your PagerDuty account
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

# Note: If your account uses different priority names, update the names above
# Common variations:
# - "P1", "P2", "P3", "P4"
# - "Critical", "High", "Medium", "Low"
# - "Sev1", "Sev2", "Sev3", "Sev4"
