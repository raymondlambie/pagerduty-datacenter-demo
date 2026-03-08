# Service Event Orchestrations
# Maps Niagara severity to PagerDuty priority and adds location to title

# Power & Electrical Service Orchestration
resource "pagerduty_event_orchestration_service" "power_electrical" {
  service = pagerduty_service.power_electrical.id

  set {
    id = "start"

    # Critical with Location
    rule {
      label = "Critical with Location"
      condition {
        expression = "event.severity matches 'critical' and event.custom_details.location exists"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id

        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    # Error with Location
    rule {
      label = "Error with Location"
      condition {
        expression = "event.severity matches 'error' and event.custom_details.location exists"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id

        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    # Warning with Location
    rule {
      label = "Warning with Location"
      condition {
        expression = "event.severity matches 'warning' and event.custom_details.location exists"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id

        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    # Info with Location
    rule {
      label = "Info with Location"
      condition {
        expression = "event.severity matches 'info' and event.custom_details.location exists"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id

        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    # Critical without Location
    rule {
      label = "Critical"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
      }
    }

    # Error without Location
    rule {
      label = "Error"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
      }
    }

    # Warning without Location
    rule {
      label = "Warning"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
      }
    }

    # Info without Location
    rule {
      label = "Info"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
      }
    }
  }

  catch_all {
    actions {}
  }

  depends_on = [pagerduty_service.power_electrical]
}

# HVAC & Cooling Service Orchestration
resource "pagerduty_event_orchestration_service" "hvac_cooling" {
  service = pagerduty_service.hvac_cooling.id

  set {
    id = "start"

    rule {
      label = "Critical with Location"
      condition {
        expression = "event.severity matches 'critical' and event.custom_details.location exists"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Error with Location"
      condition {
        expression = "event.severity matches 'error' and event.custom_details.location exists"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Warning with Location"
      condition {
        expression = "event.severity matches 'warning' and event.custom_details.location exists"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Info with Location"
      condition {
        expression = "event.severity matches 'info' and event.custom_details.location exists"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Critical"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
      }
    }

    rule {
      label = "Error"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
      }
    }

    rule {
      label = "Warning"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
      }
    }

    rule {
      label = "Info"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
      }
    }
  }

  catch_all {
    actions {}
  }

  depends_on = [pagerduty_service.hvac_cooling]
}

# Environmental Monitoring Service Orchestration
resource "pagerduty_event_orchestration_service" "environmental_monitoring" {
  service = pagerduty_service.environmental_monitoring.id

  set {
    id = "start"

    rule {
      label = "Critical with Location"
      condition {
        expression = "event.severity matches 'critical' and event.custom_details.location exists"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Error with Location"
      condition {
        expression = "event.severity matches 'error' and event.custom_details.location exists"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Warning with Location"
      condition {
        expression = "event.severity matches 'warning' and event.custom_details.location exists"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Info with Location"
      condition {
        expression = "event.severity matches 'info' and event.custom_details.location exists"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Critical"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
      }
    }

    rule {
      label = "Error"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
      }
    }

    rule {
      label = "Warning"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
      }
    }

    rule {
      label = "Info"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
      }
    }
  }

  catch_all {
    actions {}
  }

  depends_on = [pagerduty_service.environmental_monitoring]
}

# Physical Security Service Orchestration
resource "pagerduty_event_orchestration_service" "physical_security" {
  service = pagerduty_service.physical_security.id

  set {
    id = "start"

    rule {
      label = "Critical with Location"
      condition {
        expression = "event.severity matches 'critical' and event.custom_details.location exists"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Error with Location"
      condition {
        expression = "event.severity matches 'error' and event.custom_details.location exists"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Warning with Location"
      condition {
        expression = "event.severity matches 'warning' and event.custom_details.location exists"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Info with Location"
      condition {
        expression = "event.severity matches 'info' and event.custom_details.location exists"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Critical"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
      }
    }

    rule {
      label = "Error"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
      }
    }

    rule {
      label = "Warning"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
      }
    }

    rule {
      label = "Info"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
      }
    }
  }

  catch_all {
    actions {}
  }

  depends_on = [pagerduty_service.physical_security]
}

# Fire Safety Service Orchestration
resource "pagerduty_event_orchestration_service" "fire_safety" {
  service = pagerduty_service.fire_safety.id

  set {
    id = "start"

    rule {
      label = "Critical with Location"
      condition {
        expression = "event.severity matches 'critical' and event.custom_details.location exists"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Error with Location"
      condition {
        expression = "event.severity matches 'error' and event.custom_details.location exists"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Warning with Location"
      condition {
        expression = "event.severity matches 'warning' and event.custom_details.location exists"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Info with Location"
      condition {
        expression = "event.severity matches 'info' and event.custom_details.location exists"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Critical"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
      }
    }

    rule {
      label = "Error"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
      }
    }

    rule {
      label = "Warning"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
      }
    }

    rule {
      label = "Info"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
      }
    }
  }

  catch_all {
    actions {}
  }

  depends_on = [pagerduty_service.fire_safety]
}

# Network Infrastructure Service Orchestration
resource "pagerduty_event_orchestration_service" "network_infrastructure" {
  service = pagerduty_service.network_infrastructure.id

  set {
    id = "start"

    rule {
      label = "Critical with Location"
      condition {
        expression = "event.severity matches 'critical' and event.custom_details.location exists"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Error with Location"
      condition {
        expression = "event.severity matches 'error' and event.custom_details.location exists"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Warning with Location"
      condition {
        expression = "event.severity matches 'warning' and event.custom_details.location exists"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Info with Location"
      condition {
        expression = "event.severity matches 'info' and event.custom_details.location exists"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
        variable {
          name  = "loc"
          path  = "event.custom_details.location"
          type  = "regex"
          value = "(.*)"
        }
        variable {
          name  = "sum"
          path  = "event.summary"
          type  = "regex"
          value = "(.*)"
        }
        extraction {
          template = "[{{variables.loc}}] {{variables.sum}}"
          target   = "event.summary"
        }
      }
    }

    rule {
      label = "Critical"
      condition {
        expression = "event.severity matches 'critical'"
      }
      actions {
        severity = "critical"
        priority = data.pagerduty_priority.p1_critical.id
      }
    }

    rule {
      label = "Error"
      condition {
        expression = "event.severity matches 'error'"
      }
      actions {
        severity = "error"
        priority = data.pagerduty_priority.p2_high.id
      }
    }

    rule {
      label = "Warning"
      condition {
        expression = "event.severity matches 'warning'"
      }
      actions {
        severity = "warning"
        priority = data.pagerduty_priority.p3_low.id
      }
    }

    rule {
      label = "Info"
      condition {
        expression = "event.severity matches 'info'"
      }
      actions {
        severity = "info"
        priority = data.pagerduty_priority.p4_low.id
      }
    }
  }

  catch_all {
    actions {}
  }

  depends_on = [pagerduty_service.network_infrastructure]
}
