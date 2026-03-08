# Critical Infrastructure Escalation Policy
resource "pagerduty_escalation_policy" "critical_infrastructure" {
  name      = "Critical Infrastructure"
  num_loops = 3
  teams     = [pagerduty_team.datacenter_ops.id]

  rule {
    escalation_delay_in_minutes = 5

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.primary_oncall.id
    }
  }

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.management_escalation.id
    }
  }
}

# Environmental Systems Escalation Policy
resource "pagerduty_escalation_policy" "environmental_systems" {
  name      = "Environmental Systems"
  num_loops = 3
  teams     = [pagerduty_team.environmental.id]

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.environmental_oncall.id
    }
  }

  rule {
    escalation_delay_in_minutes = 15

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.primary_oncall.id
    }
  }

  rule {
    escalation_delay_in_minutes = 20

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.management_escalation.id
    }
  }
}

# Security Response Escalation Policy
resource "pagerduty_escalation_policy" "security_response" {
  name      = "Security Response"
  num_loops = 5
  teams     = [pagerduty_team.security.id]

  rule {
    escalation_delay_in_minutes = 1

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.security_oncall.id
    }
  }

  rule {
    escalation_delay_in_minutes = 5

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.management_escalation.id
    }
  }
}

# Power & Electrical Escalation Policy
resource "pagerduty_escalation_policy" "power_electrical" {
  name      = "Power and Electrical Systems"
  num_loops = 5
  teams     = [pagerduty_team.datacenter_ops.id]

  rule {
    escalation_delay_in_minutes = 1

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.power_specialists.id
    }
  }

  rule {
    escalation_delay_in_minutes = 5

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.primary_oncall.id
    }
  }

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.management_escalation.id
    }
  }
}

# Life Safety Critical Escalation Policy
resource "pagerduty_escalation_policy" "life_safety_critical" {
  name      = "Life Safety Critical"
  num_loops = 9
  teams     = [pagerduty_team.datacenter_ops.id]

  rule {
    escalation_delay_in_minutes = 1

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.security_oncall.id
    }

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.primary_oncall.id
    }
  }

  rule {
    escalation_delay_in_minutes = 3

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.power_specialists.id
    }

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.environmental_oncall.id
    }
  }

  rule {
    escalation_delay_in_minutes = 5

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.management_escalation.id
    }
  }
}

# Network Infrastructure Escalation Policy
resource "pagerduty_escalation_policy" "network_infrastructure" {
  name      = "Network Infrastructure"
  num_loops = 3
  teams     = [pagerduty_team.datacenter_ops.id]

  rule {
    escalation_delay_in_minutes = 5

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.primary_oncall.id
    }
  }

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.after_hours.id
    }
  }

  rule {
    escalation_delay_in_minutes = 15

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.management_escalation.id
    }
  }
}
