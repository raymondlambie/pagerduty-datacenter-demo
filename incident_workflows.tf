# Critical Environmental Incident Workflow
resource "pagerduty_incident_workflow" "critical_environmental" {
  name        = "Critical Environmental Event"
  description = "Automated workflow for critical temperature or environmental alerts"

  step {
    name   = "notify_management"
    action = "pagerduty.com:incident-workflows:send-status-update:1"

    input {
      name  = "message"
      value = "Critical environmental alert detected. Environmental and Infrastructure teams have been notified."
    }
  }

  step {
    name   = "add_conference_bridge"
    action = "pagerduty.com:incident-workflows:add-conference-bridge:1"

    input {
      name  = "conference_url"
      value = var.conference_bridge_url
    }

    input {
      name  = "conference_number"
      value = var.conference_bridge_url
    }
  }
}

resource "pagerduty_incident_workflow_trigger" "critical_environmental_trigger" {
  type                        = "conditional"
  workflow                    = pagerduty_incident_workflow.critical_environmental.id
  subscribed_to_all_services  = false
  services                    = [pagerduty_service.environmental_monitoring.id]

  condition                   = "incident.urgency == \"high\""
}

# Power Failure Incident Workflow
resource "pagerduty_incident_workflow" "power_failure" {
  name        = "Power Failure Response"
  description = "Immediate automated response for UPS, generator, or power distribution failures"

  step {
    name   = "notify_critical_power_failure"
    action = "pagerduty.com:incident-workflows:send-status-update:1"

    input {
      name  = "message"
      value = "CRITICAL: Power system failure detected. Power specialists and infrastructure teams engaged."
    }
  }

  step {
    name   = "add_conference_bridge"
    action = "pagerduty.com:incident-workflows:add-conference-bridge:1"

    input {
      name  = "conference_url"
      value = var.conference_bridge_url
    }

    input {
      name  = "conference_number"
      value = var.conference_bridge_url
    }
  }

  step {
    name   = "add_responders"
    action = "pagerduty.com:incident-workflows:add-responders:1"

    input {
      name  = "responders"
      value = jsonencode([
        {
          type = "user_reference"
          id   = pagerduty_user.jennifer_brooks.id
        },
        {
          type = "user_reference"
          id   = pagerduty_user.alex_turner.id
        }
      ])
    }
  }
}

resource "pagerduty_incident_workflow_trigger" "power_failure_trigger" {
  type                        = "conditional"
  workflow                    = pagerduty_incident_workflow.power_failure.id
  subscribed_to_all_services  = false
  services                    = [pagerduty_service.power_electrical.id]

  condition                   = "incident.priority != null"
}

# Security Breach Incident Workflow
resource "pagerduty_incident_workflow" "security_breach" {
  name        = "Security Breach Response"
  description = "Immediate automated response for unauthorized access or security breaches"

  step {
    name   = "notify_security_breach"
    action = "pagerduty.com:incident-workflows:send-status-update:1"

    input {
      name  = "message"
      value = "SECURITY ALERT: Unauthorized access or breach detected. Security team and management notified immediately."
    }
  }

  step {
    name   = "add_conference_bridge"
    action = "pagerduty.com:incident-workflows:add-conference-bridge:1"

    input {
      name  = "conference_url"
      value = var.conference_bridge_url
    }

    input {
      name  = "conference_number"
      value = var.conference_bridge_url
    }
  }

  step {
    name   = "add_responders"
    action = "pagerduty.com:incident-workflows:add-responders:1"

    input {
      name  = "responders"
      value = jsonencode([
        {
          type = "user_reference"
          id   = pagerduty_user.jennifer_brooks.id
        },
        {
          type = "user_reference"
          id   = pagerduty_user.james_murphy.id
        }
      ])
    }
  }
}

resource "pagerduty_incident_workflow_trigger" "security_breach_trigger" {
  type                        = "conditional"
  workflow                    = pagerduty_incident_workflow.security_breach.id
  subscribed_to_all_services  = false
  services                    = [pagerduty_service.physical_security.id]

  condition                   = "incident.priority != null"
}

# Fire & Life Safety Critical Workflow
resource "pagerduty_incident_workflow" "fire_life_safety" {
  name        = "Fire & Life Safety Critical"
  description = "Immediate response for fire detection and life safety systems"

  step {
    name   = "notify_life_safety_critical"
    action = "pagerduty.com:incident-workflows:send-status-update:1"

    input {
      name  = "message"
      value = "🚨 LIFE SAFETY CRITICAL: Fire or life safety system alert. All teams notified. Emergency protocols activated."
    }
  }

  step {
    name   = "add_conference_bridge"
    action = "pagerduty.com:incident-workflows:add-conference-bridge:1"

    input {
      name  = "conference_url"
      value = var.conference_bridge_url
    }

    input {
      name  = "conference_number"
      value = var.conference_bridge_url
    }
  }

  step {
    name   = "add_all_responders"
    action = "pagerduty.com:incident-workflows:add-responders:1"

    input {
      name  = "responders"
      value = jsonencode([
        {
          type = "user_reference"
          id   = pagerduty_user.jennifer_brooks.id
        },
        {
          type = "user_reference"
          id   = pagerduty_user.robert_taylor.id
        },
        {
          type = "user_reference"
          id   = pagerduty_user.james_murphy.id
        },
        {
          type = "user_reference"
          id   = pagerduty_user.alex_turner.id
        }
      ])
    }
  }
}

resource "pagerduty_incident_workflow_trigger" "fire_life_safety_trigger" {
  type                        = "conditional"
  workflow                    = pagerduty_incident_workflow.fire_life_safety.id
  subscribed_to_all_services  = false
  services                    = [pagerduty_service.fire_safety.id]

  condition                   = "incident.priority != null"
}
