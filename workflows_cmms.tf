# ============================================================================
# CMMS INTEGRATION WORKFLOW (Manual Prompt Version)
# ============================================================================
# Prompts responders to create CMMS work order with pre-filled details
# Note: Automatic webhook creation not available in current PagerDuty plan

resource "pagerduty_incident_workflow" "cmms_integration" {
  name        = "CMMS Work Order Prompt"
  description = "Prompts responder to create CMMS work order with incident details"

  step {
    name   = "cmms_creation_prompt"
    action = "pagerduty.com:incident-workflows:send-status-update:1"

    input {
      name  = "message"
      value = <<-EOT
📋 CMMS WORK ORDER REQUIRED

Please create a CMMS work order with the following details:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🆔 PagerDuty Incident: {{incident.id}}
📌 Title: {{incident.title}}
⚠️ Urgency: {{incident.urgency}}
🎯 Priority: {{incident.priority.summary}}
🔧 Service: {{incident.service.summary}}
🕐 Created: {{incident.created_at}}
🔗 Link: {{incident.html_url}}

After creating the CMMS ticket, reply with:
"CMMS Work Order #[NUMBER] created"
EOT
    }
  }
}

# Trigger for all high-urgency incidents across all services
resource "pagerduty_incident_workflow_trigger" "cmms_high_urgency" {
  type                       = "conditional"
  workflow                   = pagerduty_incident_workflow.cmms_integration.id
  subscribed_to_all_services = true
  condition                  = "incident.urgency == 'high'"
}
