# HVAC System Response Workflow
resource "pagerduty_incident_workflow" "hvac_response_prompt" {
  name        = "HVAC System Response Guide"
  description = "Prompts HVAC responders with structured update template"

  step {
    name   = "hvac_initial_prompt"
    action = "pagerduty.com:incident-workflows:send-status-update:1"

    input {
      name  = "message"
      value = <<-EOT
🌡️ HVAC INCIDENT RESPONSE CHECKLIST

Please provide the following information:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 Affected Zone(s): [e.g., Zone 3, Server Room A]
🌡️ Current Temperature: [°C]
🎯 Target Temperature: [°C]
📊 Impact Level: [None/Low/Medium/High/Critical]
🔄 Redundancy Status: [Active/Partial/Failed/N/A]
⏱️ ETA to Resolution: [e.g., 30 minutes]
🔧 Actions Taken: [Brief description]

Reply with status updates as situation evolves.
EOT
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

  # MS Teams Chat Creation Step
  step {
    name   = "create_ms_teams_chat"
    action = "pagerduty.com:microsoft-teams:create-ms-teams-chat:2"

    input {
      name  = "Microsoft Teams Organization"
      value = var.msteams_org_id
    }

    input {
      name  = "User"
      value = var.msteams_user_id
    }

    input {
      name  = "Chat Name"
      value = "incident_{{incident.incident_number}}"
    }
  }
}

resource "pagerduty_incident_workflow_trigger" "hvac_trigger" {
  type                       = "conditional"
  workflow                   = pagerduty_incident_workflow.hvac_response_prompt.id
  subscribed_to_all_services = false
  services                   = [pagerduty_service.hvac_cooling.id]
  condition                  = "incident.priority"
}

# Power System Response Workflow
resource "pagerduty_incident_workflow" "power_response_prompt" {
  name        = "Power System Response Guide"
  description = "Prompts power responders with structured update template"

  step {
    name   = "power_initial_prompt"
    action = "pagerduty.com:incident-workflows:send-status-update:1"

    input {
      name  = "message"
      value = <<-EOT
⚡ POWER SYSTEM INCIDENT RESPONSE CHECKLIST

Please provide the following information:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 Affected System: [UPS/Generator/PDU/Circuit]
🔋 Power Load: [%]
⏱️ Battery Runtime: [minutes remaining]
🔄 Redundancy Status: [Active/Partial/Failed/N/A]
📊 Impact Level: [None/Low/Medium/High/Critical]
👥 Customer Impact: [None/Minimal/Moderate/Severe]
⏱️ ETA to Resolution: [e.g., 1 hour]
🔧 Actions Taken: [Brief description]

Reply with status updates as situation evolves.
EOT
    }
  }

  step {
    name   = "add_power_specialists"
    action = "pagerduty.com:incident-workflows:add-responders:1"

    input {
      name  = "responders"
      value = jsonencode([
        {
          type = "user_reference"
          id   = pagerduty_user.alex_turner.id
        }
      ])
    }
  }
}

resource "pagerduty_incident_workflow_trigger" "power_trigger" {
  type                       = "conditional"
  workflow                   = pagerduty_incident_workflow.power_response_prompt.id
  subscribed_to_all_services = false
  services                   = [pagerduty_service.power_electrical.id]
  condition                  = "incident.priority"
}

# Network System Response Workflow
resource "pagerduty_incident_workflow" "network_response_prompt" {
  name        = "Network System Response Guide"
  description = "Prompts network responders with structured update template"

  step {
    name   = "network_initial_prompt"
    action = "pagerduty.com:incident-workflows:send-status-update:1"

    input {
      name  = "message"
      value = <<-EOT
🌐 NETWORK INCIDENT RESPONSE CHECKLIST

Please provide the following information:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 Affected Segment: [VLAN/Switch/Router]
🔄 Failover Status: [Successful/Failed/In Progress/N/A]
📊 Impact Level: [None/Low/Medium/High/Critical]
👥 Customer Impact: [None/Minimal/Moderate/Severe]
⏱️ ETA to Resolution: [e.g., 45 minutes]
🔍 Root Cause: [If identified]
🔧 Actions Taken: [Brief description]

Reply with status updates as situation evolves.
EOT
    }
  }
}

resource "pagerduty_incident_workflow_trigger" "network_trigger" {
  type                       = "conditional"
  workflow                   = pagerduty_incident_workflow.network_response_prompt.id
  subscribed_to_all_services = false
  services                   = [pagerduty_service.network_infrastructure.id]
  condition                  = "incident.priority"
}

# Security System Response Workflow
resource "pagerduty_incident_workflow" "security_response_prompt" {
  name        = "Security System Response Guide"
  description = "Prompts security responders with structured update template"

  step {
    name   = "security_initial_prompt"
    action = "pagerduty.com:incident-workflows:send-status-update:1"

    input {
      name  = "message"
      value = <<-EOT
🔒 SECURITY INCIDENT RESPONSE CHECKLIST

Please provide the following information:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 Location: [e.g., Main Entrance, Server Room Door 3]
📹 Video Footage: [Captured/Under Review/Not Available/N/A]
📊 Impact Level: [None/Low/Medium/High/Critical]
🚨 Threat Level: [Low/Medium/High]
⏱️ ETA to Resolution: [e.g., 20 minutes]
🔍 Incident Type: [Unauthorized Access/Breach/Alarm/Other]
🔧 Actions Taken: [Brief description]

Reply with status updates as situation evolves.
EOT
    }
  }

  step {
    name   = "add_security_management"
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

resource "pagerduty_incident_workflow_trigger" "security_trigger" {
  type                       = "conditional"
  workflow                   = pagerduty_incident_workflow.security_response_prompt.id
  subscribed_to_all_services = false
  services                   = [pagerduty_service.physical_security.id]
  condition                  = "incident.priority"
}
