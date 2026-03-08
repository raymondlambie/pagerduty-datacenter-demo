# Event Orchestrations for Niagara BMS Alert Mapping
# Maps Niagara severity levels to PagerDuty priorities

# Power & Electrical Service Orchestration
resource "pagerduty_event_orchestration_service" "power_electrical" {
  service = pagerduty_service.power_electrical.id

  set {
    id = "start"

    # UPS and power failures are critical
    rule {
      label = "Power System Critical"
      condition {
        expression = "event.source matches part 'UPS' or event.source matches part 'PDU' or event.source matches part 'GEN'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 POWER SYSTEM ALERT - Critical infrastructure affected"
      }
    }

    # Suppress maintenance windows
    rule {
      label = "Suppress Maintenance"
      condition {
        expression = "event.custom_details.maintenance_mode matches 'true' or event.summary matches part '[MAINTENANCE]'"
      }
      actions {
        suppress  = true
        annotate  = "Suppressed: Scheduled maintenance window"
      }
    }

    rule {
      label = "Map Critical Severity to P1"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 CRITICAL: Power/Electrical - Immediate Response Required"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Error Severity to P2"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity  = "error"
        priority  = data.pagerduty_priority.p2_high.id
        annotate  = "⚠️ ERROR: Power/Electrical - Urgent Attention Needed"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Warning Severity to P3"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity  = "warning"
        priority  = data.pagerduty_priority.p3_low.id
        annotate  = "⚡ WARNING: Power/Electrical - Monitor Situation"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Info Severity to P4"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity  = "info"
        priority  = data.pagerduty_priority.p4_low.id
        annotate  = "ℹ️ INFO: Power/Electrical - Informational Alert"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }
  }

  catch_all {
    actions {
      severity = "warning"
      annotate = "⚠️ Unknown severity from Niagara BMS - defaulting to warning"
    }
  }

  depends_on = [pagerduty_service.power_electrical]
}

# HVAC & Cooling Service Orchestration
resource "pagerduty_event_orchestration_service" "hvac_cooling" {
  service = pagerduty_service.hvac_cooling.id

  set {
    id = "start"

    # Critical HVAC failures
    rule {
      label = "Critical HVAC Failure"
      condition {
        expression = "event.source matches part 'HVAC' and event.severity matches 'critical'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 CRITICAL HVAC FAILURE - Temperature rise imminent"

        extraction {
          target = "event.custom_details.unit_id"
          regex  = "HVAC-(\\w+)-(\\d+)"
          source = "event.source"
        }
      }
    }

    # CRAC unit failures are critical
    rule {
      label = "CRAC Unit Failure"
      condition {
        expression = "event.source matches part 'CRAC'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 CRAC unit failure - Server cooling at risk"
      }
    }

    # Chiller alerts
    rule {
      label = "Chiller System Alert"
      condition {
        expression = "event.source matches part 'Chiller'"
      }
      actions {
        annotate  = "⚠️ Chiller system alert - Monitor temperature trends"

        extraction {
          target = "event.custom_details.unit_id"
          regex  = "Chiller-(\\w+)-(\\d+)"
          source = "event.source"
        }
      }
    }

    # Suppress maintenance windows
    rule {
      label = "Suppress Maintenance"
      condition {
        expression = "event.custom_details.maintenance_mode matches 'true' or event.summary matches part '[MAINTENANCE]'"
      }
      actions {
        suppress  = true
        annotate  = "Suppressed: Scheduled maintenance window"
      }
    }

    rule {
      label = "Map Critical Severity to P1"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 CRITICAL: HVAC/Cooling - Immediate Response Required"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Error Severity to P2"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity  = "error"
        priority  = data.pagerduty_priority.p2_high.id
        annotate  = "⚠️ ERROR: HVAC/Cooling - Urgent Attention Needed"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Warning Severity to P3"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity  = "warning"
        priority  = data.pagerduty_priority.p3_low.id
        annotate  = "⚡ WARNING: HVAC/Cooling - Monitor Situation"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Info Severity to P4"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity  = "info"
        priority  = data.pagerduty_priority.p4_low.id
        annotate  = "ℹ️ INFO: HVAC/Cooling - Informational Alert"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }
  }

  catch_all {
    actions {
      severity = "warning"
      annotate = "⚠️ Unknown severity from Niagara BMS - defaulting to warning"
    }
  }

  depends_on = [pagerduty_service.hvac_cooling]
}

# Environmental Monitoring Service Orchestration
resource "pagerduty_event_orchestration_service" "environmental_monitoring" {
  service = pagerduty_service.environmental_monitoring.id

  set {
    id = "start"

    # Critical temperature alerts
    rule {
      label = "Critical Temperature Alert"
      condition {
        expression = "event.custom_details.component matches part 'Temperature' and event.severity matches 'critical'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 CRITICAL TEMPERATURE ALERT - Immediate response required"

        extraction {
          target = "event.custom_details.sensor_location"
          regex  = ".*-(\\w+)-(\\d+)"
          source = "event.source"
        }
      }
    }

    # Water leak detection - escalate immediately
    rule {
      label = "Water Leak Detection"
      condition {
        expression = "event.source matches part 'WATER-SENSOR'"
      }
      actions {
        severity  = "error"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 WATER LEAK DETECTED - Facilities response required"
      }
    }

    # Standard environmental monitoring
    rule {
      label = "Standard Environmental Monitoring"
      condition {
        expression = "event.source matches part 'TEMP-SENSOR' or event.source matches part 'HUMIDITY'"
      }
      actions {
        annotate  = "🌡️ Environmental monitoring alert - Check BMS dashboard"

        extraction {
          target = "event.custom_details.sensor_location"
          regex  = ".*-(\\w+)-(\\d+)"
          source = "event.source"
        }
      }
    }

    # Suppress maintenance windows
    rule {
      label = "Suppress Maintenance"
      condition {
        expression = "event.custom_details.maintenance_mode matches 'true' or event.summary matches part '[MAINTENANCE]'"
      }
      actions {
        suppress  = true
        annotate  = "Suppressed: Scheduled maintenance window"
      }
    }

    rule {
      label = "Map Critical Severity to P1"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 CRITICAL: Environmental - Immediate Response Required"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Error Severity to P2"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity  = "error"
        priority  = data.pagerduty_priority.p2_high.id
        annotate  = "⚠️ ERROR: Environmental - Urgent Attention Needed"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Warning Severity to P3"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity  = "warning"
        priority  = data.pagerduty_priority.p3_low.id
        annotate  = "⚡ WARNING: Environmental - Monitor Situation"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Info Severity to P4"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity  = "info"
        priority  = data.pagerduty_priority.p4_low.id
        annotate  = "ℹ️ INFO: Environmental - Informational Alert"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }
  }

  catch_all {
    actions {
      severity = "warning"
      annotate = "⚠️ Unknown severity from Niagara BMS - defaulting to warning"
    }
  }

  depends_on = [pagerduty_service.environmental_monitoring]
}

# Physical Security Service Orchestration
resource "pagerduty_event_orchestration_service" "physical_security" {
  service = pagerduty_service.physical_security.id

  set {
    id = "start"

    # All security alerts are high priority
    rule {
      label = "Security Alert"
      condition {
        expression = "event.severity matches 'critical' or event.severity matches 'error'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 SECURITY ALERT - Immediate response required"
      }
    }

    # Suppress maintenance windows
    rule {
      label = "Suppress Maintenance"
      condition {
        expression = "event.custom_details.maintenance_mode matches 'true' or event.summary matches part '[MAINTENANCE]'"
      }
      actions {
        suppress  = true
        annotate  = "Suppressed: Scheduled maintenance window"
      }
    }

    rule {
      label = "Map Critical Severity to P1"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 CRITICAL: Physical Security - Immediate Response Required"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Error Severity to P2"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity  = "error"
        priority  = data.pagerduty_priority.p2_high.id
        annotate  = "⚠️ ERROR: Physical Security - Urgent Attention Needed"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Warning Severity to P3"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity  = "warning"
        priority  = data.pagerduty_priority.p3_low.id
        annotate  = "⚡ WARNING: Physical Security - Monitor Situation"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Info Severity to P4"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity  = "info"
        priority  = data.pagerduty_priority.p4_low.id
        annotate  = "ℹ️ INFO: Physical Security - Informational Alert"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }
  }

  catch_all {
    actions {
      severity = "warning"
      annotate = "⚠️ Unknown severity from Niagara BMS - defaulting to warning"
    }
  }

  depends_on = [pagerduty_service.physical_security]
}

# Fire Safety Service Orchestration
resource "pagerduty_event_orchestration_service" "fire_safety" {
  service = pagerduty_service.fire_safety.id

  set {
    id = "start"

    rule {
      label = "Map Critical Severity to P1"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 CRITICAL: Fire Safety - Immediate Response Required"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Error Severity to P2"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity  = "error"
        priority  = data.pagerduty_priority.p2_high.id
        annotate  = "⚠️ ERROR: Fire Safety - Urgent Attention Needed"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Warning Severity to P3"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity  = "warning"
        priority  = data.pagerduty_priority.p3_low.id
        annotate  = "⚡ WARNING: Fire Safety - Monitor Situation"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Info Severity to P4"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity  = "info"
        priority  = data.pagerduty_priority.p4_low.id
        annotate  = "ℹ️ INFO: Fire Safety - Informational Alert"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }
  }

  catch_all {
    actions {
      severity = "warning"
      annotate = "⚠️ Unknown severity from Niagara BMS - defaulting to warning"
    }
  }

  depends_on = [pagerduty_service.fire_safety]
}

# Network Infrastructure Service Orchestration
resource "pagerduty_event_orchestration_service" "network_infrastructure" {
  service = pagerduty_service.network_infrastructure.id

  set {
    id = "start"

    # Core network failures
    rule {
      label = "Core Network Failure"
      condition {
        expression = "event.source matches part 'CORE' or event.source matches part 'SWITCH-CORE'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 CORE NETWORK FAILURE - Multiple systems affected"

        extraction {
          target = "event.custom_details.device_location"
          regex  = "SWITCH-(\\w+)-(\\w+)-(\\d+)"
          source = "event.source"
        }
      }
    }

    # Access switch failures are lower priority
    rule {
      label = "Access Switch Issue"
      condition {
        expression = "event.source matches part 'ACCESS'"
      }
      actions {
        severity  = "warning"
        priority  = data.pagerduty_priority.p3_low.id
        annotate  = "⚠️ Access switch issue - Limited impact"
      }
    }

    # Suppress low severity info alerts
    rule {
      label = "Suppress Info Alerts"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        suppress  = true
        annotate  = "Suppressed: Low severity informational alert"
      }
    }

    # Suppress maintenance windows
    rule {
      label = "Suppress Maintenance"
      condition {
        expression = "event.custom_details.maintenance_mode matches 'true' or event.summary matches part '[MAINTENANCE]'"
      }
      actions {
        suppress  = true
        annotate  = "Suppressed: Scheduled maintenance window"
      }
    }

    rule {
      label = "Map Critical Severity to P1"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity  = "critical"
        priority  = data.pagerduty_priority.p1_critical.id
        annotate  = "🚨 CRITICAL: Network Infrastructure - Immediate Response Required"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Error Severity to P2"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity  = "error"
        priority  = data.pagerduty_priority.p2_high.id
        annotate  = "⚠️ ERROR: Network Infrastructure - Urgent Attention Needed"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Warning Severity to P3"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity  = "warning"
        priority  = data.pagerduty_priority.p3_low.id
        annotate  = "⚡ WARNING: Network Infrastructure - Monitor Situation"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }

    rule {
      label = "Map Info Severity to P4"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity  = "info"
        priority  = data.pagerduty_priority.p4_low.id
        annotate  = "ℹ️ INFO: Network Infrastructure - Informational Alert"

        variable {
          name  = "niagara_severity"
          path  = "event.severity"
          type  = "regex"
          value = "(.*)"
        }
      }
    }
  }

  catch_all {
    actions {
      severity = "warning"
      annotate = "⚠️ Unknown severity from Niagara BMS - defaulting to warning"
    }
  }

  depends_on = [pagerduty_service.network_infrastructure]
}
