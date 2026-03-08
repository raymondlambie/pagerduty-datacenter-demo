
# Additional Events API v2 Integrations for Demo Event Generator
# Add this to your services.tf file

# Events API v2 Integration - Environmental Monitoring
resource "pagerduty_service_integration" "environmental_events_v2" {
  name    = "Events API v2"
  service = pagerduty_service.environmental_monitoring.id
  type    = "events_api_v2_inbound_integration"
}

# Events API v2 Integration - Fire Safety
resource "pagerduty_service_integration" "fire_safety_events_v2" {
  name    = "Events API v2"
  service = pagerduty_service.fire_safety.id
  type    = "events_api_v2_inbound_integration"
}

# Events API v2 Integration - HVAC Cooling
resource "pagerduty_service_integration" "hvac_events_v2" {
  name    = "Events API v2"
  service = pagerduty_service.hvac_cooling.id
  type    = "events_api_v2_inbound_integration"
}

# Events API v2 Integration - Network Infrastructure
resource "pagerduty_service_integration" "network_events_v2" {
  name    = "Events API v2"
  service = pagerduty_service.network_infrastructure.id
  type    = "events_api_v2_inbound_integration"
}

# Events API v2 Integration - Physical Security
resource "pagerduty_service_integration" "physical_security_events_v2" {
  name    = "Events API v2"
  service = pagerduty_service.physical_security.id
  type    = "events_api_v2_inbound_integration"
}

# Events API v2 Integration - Power & Electrical
resource "pagerduty_service_integration" "power_events_v2" {
  name    = "Events API v2"
  service = pagerduty_service.power_electrical.id
  type    = "events_api_v2_inbound_integration"
}
