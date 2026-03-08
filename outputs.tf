# Outputs for PagerDuty Datacenter Demo

# Team IDs
output "team_ids" {
  description = "Map of team names to their IDs"
  value = {
    datacenter_ops = pagerduty_team.datacenter_ops.id
    environmental  = pagerduty_team.environmental.id
    management     = pagerduty_team.management.id
    security       = pagerduty_team.security.id
  }
}

# Service IDs
output "service_ids" {
  description = "Map of service names to their IDs"
  value = {
    environmental_monitoring = pagerduty_service.environmental_monitoring.id
    fire_safety             = pagerduty_service.fire_safety.id
    hvac_cooling            = pagerduty_service.hvac_cooling.id
    network_infrastructure  = pagerduty_service.network_infrastructure.id
    physical_security       = pagerduty_service.physical_security.id
    power_electrical        = pagerduty_service.power_electrical.id
  }
}

# Service Integration Keys (for sending events via Events API v2)
output "service_integration_keys" {
  description = "Integration keys for sending events to services"
  sensitive   = true
  value = {
    environmental_monitoring = pagerduty_service_integration.environmental_events_v2.integration_key
    fire_safety             = pagerduty_service_integration.fire_safety_events_v2.integration_key
    hvac_cooling            = pagerduty_service_integration.hvac_events_v2.integration_key
    network_infrastructure  = pagerduty_service_integration.network_events_v2.integration_key
    physical_security       = pagerduty_service_integration.physical_security_events_v2.integration_key
    power_electrical        = pagerduty_service_integration.power_events_v2.integration_key
  }
}

# Escalation Policy IDs
output "escalation_policy_ids" {
  description = "Map of escalation policy names to their IDs"
  value = {
    critical_infrastructure = pagerduty_escalation_policy.critical_infrastructure.id
    environmental_systems   = pagerduty_escalation_policy.environmental_systems.id
    network_infrastructure  = pagerduty_escalation_policy.network_infrastructure.id
    power_electrical        = pagerduty_escalation_policy.power_electrical.id
    security_response       = pagerduty_escalation_policy.security_response.id
    life_safety_critical    = pagerduty_escalation_policy.life_safety_critical.id
  }
}

# Schedule IDs
output "schedule_ids" {
  description = "Map of schedule names to their IDs"
  value = {
    primary_oncall         = pagerduty_schedule.primary_oncall.id
    after_hours            = pagerduty_schedule.after_hours.id
    business_hours         = pagerduty_schedule.business_hours.id
    environmental_oncall   = pagerduty_schedule.environmental_oncall.id
    security_oncall        = pagerduty_schedule.security_oncall.id
    power_specialists      = pagerduty_schedule.power_specialists.id
    management_escalation  = pagerduty_schedule.management_escalation.id
  }
}

# Quick Reference - Integration Endpoints
output "integration_endpoints" {
  description = "Events API v2 endpoint (same for all services)"
  value = "https://events.pagerduty.com/v2/enqueue"
}

# Demo Information
output "demo_info" {
  description = "Quick reference for demo setup"
  value = {
    timezone                  = var.timezone
    total_teams              = 4
    total_services           = 6
    total_schedules          = 7
    total_escalation_policies = 6
  }
}

# Quick Start Guide
output "quick_start" {
  description = "Quick start instructions"
  value = <<-EOT

  ✅ PagerDuty Datacenter Demo - Setup Complete!

  📋 Next Steps:

  1. Get Integration Keys:
     terraform output -json service_integration_keys

  2. Update demo_event_generator.py with the integration keys

  3. Run the demo:
     python3 demo_event_generator.py

  4. View your PagerDuty dashboard to see incidents

  🎯 Services Available:
     • Environmental Monitoring
     • Fire Safety
     • HVAC Cooling
     • Network Infrastructure
     • Physical Security
     • Power & Electrical

  EOT
}
