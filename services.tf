# Physical Security Service
resource "pagerduty_service" "physical_security" {
  name                    = "Physical Security & Access Control"
  description             = "Door access, intrusion detection, and physical security alerts"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.security_response.id
  alert_creation          = "create_alerts_and_incidents"
}

resource "pagerduty_service_integration" "physical_security_email" {
  name              = "Physical Security Email"
  service           = pagerduty_service.physical_security.id
  type              = "generic_email_inbound_integration"
  integration_email = "physical-security@pdt-rlambie.pagerduty.com"
}

resource "pagerduty_alert_grouping_setting" "physical_security" {
  name    = "Physical Security Grouping"
  type    = "intelligent"
  services = [pagerduty_service.physical_security.id]

  config {}
}

# Environmental Monitoring Service
resource "pagerduty_service" "environmental_monitoring" {
  name                    = "Environmental Monitoring"
  description             = "Temperature, humidity, water detection, and environmental sensors"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.environmental_systems.id
  alert_creation          = "create_alerts_and_incidents"
}

resource "pagerduty_service_integration" "environmental_email" {
  name              = "Environmental Email"
  service           = pagerduty_service.environmental_monitoring.id
  type              = "generic_email_inbound_integration"
  integration_email = "environmental@pdt-rlambie.pagerduty.com"
}

resource "pagerduty_alert_grouping_setting" "environmental_monitoring" {
  name    = "Environmental Grouping"
  type    = "intelligent"
  services = [pagerduty_service.environmental_monitoring.id]

  config {}
}

# HVAC & Cooling Service
resource "pagerduty_service" "hvac_cooling" {
  name                    = "HVAC & Cooling Systems"
  description             = "Air conditioning, cooling towers, and HVAC equipment"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.environmental_systems.id
  alert_creation          = "create_alerts_and_incidents"
}

resource "pagerduty_service_integration" "hvac_email" {
  name              = "HVAC Email"
  service           = pagerduty_service.hvac_cooling.id
  type              = "generic_email_inbound_integration"
  integration_email = "hvac@pdt-rlambie.pagerduty.com"
}

resource "pagerduty_alert_grouping_setting" "hvac_cooling" {
  name    = "HVAC Grouping"
  type    = "intelligent"
  services = [pagerduty_service.hvac_cooling.id]

  config {}
}

# Power & Electrical Service
resource "pagerduty_service" "power_electrical" {
  name                    = "Power & Electrical Systems"
  description             = "UPS, generators, PDUs, and electrical distribution"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 300
  escalation_policy       = pagerduty_escalation_policy.power_electrical.id
  alert_creation          = "create_alerts_and_incidents"
}

resource "pagerduty_service_integration" "power_email" {
  name              = "Power Email"
  service           = pagerduty_service.power_electrical.id
  type              = "generic_email_inbound_integration"
  integration_email = "power@pdt-rlambie.pagerduty.com"
}

resource "pagerduty_alert_grouping_setting" "power_electrical" {
  name    = "Power Grouping"
  type    = "intelligent"
  services = [pagerduty_service.power_electrical.id]

  config {}
}

# Network Infrastructure Service
resource "pagerduty_service" "network_infrastructure" {
  name                    = "Network Infrastructure"
  description             = "Network switches, routers, and connectivity monitoring"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.critical_infrastructure.id
  alert_creation          = "create_alerts_and_incidents"
}

resource "pagerduty_service_integration" "network_email" {
  name              = "Network Email"
  service           = pagerduty_service.network_infrastructure.id
  type              = "generic_email_inbound_integration"
  integration_email = "network@pdt-rlambie.pagerduty.com"
}

resource "pagerduty_alert_grouping_setting" "network_infrastructure" {
  name    = "Network Grouping"
  type    = "intelligent"
  services = [pagerduty_service.network_infrastructure.id]

  config {}
}

# Fire & Life Safety Service
resource "pagerduty_service" "fire_safety" {
  name                    = "Fire & Life Safety Systems"
  description             = "Fire detection, suppression, and life safety critical alerts"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 60
  escalation_policy       = pagerduty_escalation_policy.life_safety_critical.id
  alert_creation          = "create_alerts_and_incidents"
}

resource "pagerduty_service_integration" "fire_safety_email" {
  name              = "Fire Safety Email"
  service           = pagerduty_service.fire_safety.id
  type              = "generic_email_inbound_integration"
  integration_email = "fire-safety@pdt-rlambie.pagerduty.com"
}

resource "pagerduty_alert_grouping_setting" "fire_safety" {
  name    = "Fire Safety Grouping"
  type    = "intelligent"
  services = [pagerduty_service.fire_safety.id]

  config {}
}
