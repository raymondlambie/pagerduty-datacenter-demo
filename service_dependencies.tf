# Service Dependencies for Datacenter Infrastructure
# Power & Electrical is the foundation - everything depends on power

# Network depends on Power
resource "pagerduty_service_dependency" "network_depends_on_power" {
  dependency {
    dependent_service {
      id   = pagerduty_service.network_infrastructure.id
      type = "service"
    }
    supporting_service {
      id   = pagerduty_service.power_electrical.id
      type = "service"
    }
  }
}

# HVAC depends on Power (cooling systems need electricity)
resource "pagerduty_service_dependency" "hvac_depends_on_power" {
  dependency {
    dependent_service {
      id   = pagerduty_service.hvac_cooling.id
      type = "service"
    }
    supporting_service {
      id   = pagerduty_service.power_electrical.id
      type = "service"
    }
  }
}

# Environmental Monitoring depends on Power (sensors need power)
resource "pagerduty_service_dependency" "environmental_depends_on_power" {
  dependency {
    dependent_service {
      id   = pagerduty_service.environmental_monitoring.id
      type = "service"
    }
    supporting_service {
      id   = pagerduty_service.power_electrical.id
      type = "service"
    }
  }
}

# Environmental Monitoring also depends on HVAC (temperature monitoring)
resource "pagerduty_service_dependency" "environmental_depends_on_hvac" {
  dependency {
    dependent_service {
      id   = pagerduty_service.environmental_monitoring.id
      type = "service"
    }
    supporting_service {
      id   = pagerduty_service.hvac_cooling.id
      type = "service"
    }
  }
}

# Environmental Monitoring depends on Network (for reporting)
resource "pagerduty_service_dependency" "environmental_depends_on_network" {
  dependency {
    dependent_service {
      id   = pagerduty_service.environmental_monitoring.id
      type = "service"
    }
    supporting_service {
      id   = pagerduty_service.network_infrastructure.id
      type = "service"
    }
  }
}

# Physical Security depends on Power (access control systems need power)
resource "pagerduty_service_dependency" "security_depends_on_power" {
  dependency {
    dependent_service {
      id   = pagerduty_service.physical_security.id
      type = "service"
    }
    supporting_service {
      id   = pagerduty_service.power_electrical.id
      type = "service"
    }
  }
}

# Physical Security depends on Network (IP cameras, access control)
resource "pagerduty_service_dependency" "security_depends_on_network" {
  dependency {
    dependent_service {
      id   = pagerduty_service.physical_security.id
      type = "service"
    }
    supporting_service {
      id   = pagerduty_service.network_infrastructure.id
      type = "service"
    }
  }
}

# Fire Safety depends on Power (detection and suppression systems)
resource "pagerduty_service_dependency" "fire_depends_on_power" {
  dependency {
    dependent_service {
      id   = pagerduty_service.fire_safety.id
      type = "service"
    }
    supporting_service {
      id   = pagerduty_service.power_electrical.id
      type = "service"
    }
  }
}

# Fire Safety depends on Network (monitoring and alerts)
resource "pagerduty_service_dependency" "fire_depends_on_network" {
  dependency {
    dependent_service {
      id   = pagerduty_service.fire_safety.id
      type = "service"
    }
    supporting_service {
      id   = pagerduty_service.network_infrastructure.id
      type = "service"
    }
  }
}
