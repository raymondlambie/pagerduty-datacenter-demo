# CMMS Integration Workflow - MANUAL TRIGGER ONLY
# Responders can manually trigger this workflow from any incident
# to create a CMMS work order

resource "pagerduty_incident_workflow" "cmms_integration" {
  name        = "Create CMMS Work Order"
  description = "Manual workflow to create CMMS work order with incident details"

  step {
    name   = "cmms_creation_prompt"
    action = "pagerduty.com:incident-workflows:send-status-update:1"

    input {
      name  = "message"
      value = <<-EOT
📋 CMMS WORK ORDER CREATION

Creating CMMS work order with the following details:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🆔 PagerDuty Incident: {{incident.id}}
📌 Title: {{incident.title}}
⚠️ Urgency: {{incident.urgency}}
🎯 Priority: {{incident.priority.summary}}
🔧 Service: {{incident.service.summary}}
🕐 Created: {{incident.created_at}}
🔗 Link: {{incident.html_url}}

Please create the CMMS ticket and reply with:
"CMMS Work Order #[NUMBER] created"
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
}

# NO TRIGGER - This workflow is MANUAL ONLY
# Responders click "Run Workflow" button in PagerDuty UI
