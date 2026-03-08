# PagerDuty Services Configuration
# Sydney Datacenter - Technical Services

# Service 1: Power & Electrical Systems
resource "pagerduty_service" "power_electrical" {
  name                    = "Power & Electrical Systems"
  description            = "Critical power infrastructure including UPS, PDUs, and generators"
  auto_resolve_timeout   = 14400
  acknowledgement_timeout = 600
  escalation_policy      = pagerduty_escalation_policy.critical_infrastructure.id
  alert_creation         = "create_alerts_and_incidents"
}

resource "pagerduty_alert_grouping_setting" "power_electrical" {
  name     = "Power & Electrical Alert Grouping"
  type     = "intelligent"
  services = [pagerduty_service.power_electrical.id]

  config {}
}

# Service 2: HVAC & Cooling Systems
resource "pagerduty_service" "hvac_cooling" {
  name                    = "HVAC & Cooling Systems"
  description            = "Environmental control systems including HVAC, CRAC units, and chillers"
  auto_resolve_timeout   = 14400
  acknowledgement_timeout = 600
  escalation_policy      = pagerduty_escalation_policy.environmental_systems.id
  alert_creation         = "create_alerts_and_incidents"
}

resource "pagerduty_alert_grouping_setting" "hvac_cooling" {
  name     = "HVAC & Cooling Alert Grouping"
  type     = "intelligent"
  services = [pagerduty_service.hvac_cooling.id]

  config {}
}

# Service 3: Environmental Monitoring
resource "pagerduty_service" "environmental_monitoring" {
  name                    = "Environmental Monitoring"
  description            = "Temperature, humidity, and water leak detection systems"
  auto_resolve_timeout   = 14400
  acknowledgement_timeout = 600
  escalation_policy      = pagerduty_escalation_policy.environmental_systems.id
  alert_creation         = "create_alerts_and_incidents"
}

resource "pagerduty_alert_grouping_setting" "environmental_monitoring" {
  name     = "Environmental Monitoring Alert Grouping"
  type     = "intelligent"
  services = [pagerduty_service.environmental_monitoring.id]

  config {}
}

# Service 4: Physical Security
resource "pagerduty_service" "physical_security" {
  name                    = "Physical Security Systems"
  description            = "Access control, surveillance, and intrusion detection"
  auto_resolve_timeout   = 14400
  acknowledgement_timeout = 300
  escalation_policy      = pagerduty_escalation_policy.security_response.id
  alert_creation         = "create_alerts_and_incidents"
}

resource "pagerduty_alert_grouping_setting" "physical_security" {
  name     = "Physical Security Alert Grouping"
  type     = "intelligent"
  services = [pagerduty_service.physical_security.id]

  config {}
}

# Service 5: Fire & Life Safety
resource "pagerduty_service" "fire_safety" {
  name                    = "Fire & Life Safety Systems"
  description            = "Fire detection, suppression, and emergency systems"
  auto_resolve_timeout   = 14400
  acknowledgement_timeout = 180
  escalation_policy      = pagerduty_escalation_policy.life_safety_critical.id
  alert_creation         = "create_alerts_and_incidents"
}

resource "pagerduty_alert_grouping_setting" "fire_safety" {
  name     = "Fire & Life Safety Alert Grouping"
  type     = "time_based"
  services = [pagerduty_service.fire_safety.id]

  config {
    timeout = 300
  }
}

# Service 6: Network Infrastructure
resource "pagerduty_service" "network_infrastructure" {
  name                    = "Network Infrastructure"
  description            = "Core networking, switches, and connectivity systems"
  auto_resolve_timeout   = 14400
  acknowledgement_timeout = 900
  escalation_policy      = pagerduty_escalation_policy.network_infrastructure.id
  alert_creation         = "create_alerts_and_incidents"
}

resource "pagerduty_alert_grouping_setting" "network_infrastructure" {
  name     = "Network Infrastructure Alert Grouping"
  type     = "intelligent"
  services = [pagerduty_service.network_infrastructure.id]

  config {}
}

# MS Teams Extension for Power & Electrical
resource "pagerduty_extension" "power_electrical_msteams" {
  name              = "Power & Electrical - MS Teams"
  extension_schema  = data.pagerduty_extension_schema.msteams.id
  extension_objects = [pagerduty_service.power_electrical.id]

  config = jsonencode({
    url = var.teams_webhook_power
  })
}

# MS Teams Extension for HVAC & Cooling
resource "pagerduty_extension" "hvac_cooling_msteams" {
  name              = "HVAC & Cooling - MS Teams"
  extension_schema  = data.pagerduty_extension_schema.msteams.id
  extension_objects = [pagerduty_service.hvac_cooling.id]

  config = jsonencode({
    url = var.teams_webhook_hvac
  })
}

# MS Teams Extension for Environmental Monitoring
resource "pagerduty_extension" "environmental_monitoring_msteams" {
  name              = "Environmental Monitoring - MS Teams"
  extension_schema  = data.pagerduty_extension_schema.msteams.id
  extension_objects = [pagerduty_service.environmental_monitoring.id]

  config = jsonencode({
    url = var.teams_webhook_environmental
  })
}

# MS Teams Extension for Physical Security
resource "pagerduty_extension" "physical_security_msteams" {
  name              = "Physical Security - MS Teams"
  extension_schema  = data.pagerduty_extension_schema.msteams.id
  extension_objects = [pagerduty_service.physical_security.id]

  config = jsonencode({
    url = var.teams_webhook_security
  })
}

# MS Teams Extension for Fire & Life Safety
resource "pagerduty_extension" "fire_safety_msteams" {
  name              = "Fire & Life Safety - MS Teams"
  extension_schema  = data.pagerduty_extension_schema.msteams.id
  extension_objects = [pagerduty_service.fire_safety.id]

  config = jsonencode({
    url = var.teams_webhook_fire
  })
}

# MS Teams Extension for Network Infrastructure
resource "pagerduty_extension" "network_infrastructure_msteams" {
  name              = "Network Infrastructure - MS Teams"
  extension_schema  = data.pagerduty_extension_schema.msteams.id
  extension_objects = [pagerduty_service.network_infrastructure.id]

  config = jsonencode({
    url = var.teams_webhook_network
  })
}

# Data source for MS Teams extension schema
data "pagerduty_extension_schema" "msteams" {
  name = "Microsoft Teams"
}

# Service integrations for Niagara BMS
resource "pagerduty_service_integration" "power_electrical_niagara" {
  name    = "Niagara BMS - Power & Electrical"
  service = pagerduty_service.power_electrical.id
  vendor  = data.pagerduty_vendor.events_api_v2.id
}

resource "pagerduty_service_integration" "hvac_cooling_niagara" {
  name    = "Niagara BMS - HVAC & Cooling"
  service = pagerduty_service.hvac_cooling.id
  vendor  = data.pagerduty_vendor.events_api_v2.id
}

resource "pagerduty_service_integration" "environmental_monitoring_niagara" {
  name    = "Niagara BMS - Environmental Monitoring"
  service = pagerduty_service.environmental_monitoring.id
  vendor  = data.pagerduty_vendor.events_api_v2.id
}

resource "pagerduty_service_integration" "physical_security_niagara" {
  name    = "Niagara BMS - Physical Security"
  service = pagerduty_service.physical_security.id
  vendor  = data.pagerduty_vendor.events_api_v2.id
}

resource "pagerduty_service_integration" "fire_safety_niagara" {
  name    = "Niagara BMS - Fire & Life Safety"
  service = pagerduty_service.fire_safety.id
  vendor  = data.pagerduty_vendor.events_api_v2.id
}

resource "pagerduty_service_integration" "network_infrastructure_niagara" {
  name    = "Niagara BMS - Network Infrastructure"
  service = pagerduty_service.network_infrastructure.id
  vendor  = data.pagerduty_vendor.events_api_v2.id
}

# Data source for Events API v2 vendor
data "pagerduty_vendor" "events_api_v2" {
  name = "Events API V2"
}
