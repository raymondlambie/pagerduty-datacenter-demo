# Business Services for GreenSquareDC
# Maps technical services to business-level services for impact visibility

# Business Service 1: Datacenter Operations
resource "pagerduty_business_service" "datacenter_operations" {
  name             = "Datacenter Operations"
  description      = "Core facility operations ensuring physical infrastructure availability"
  point_of_contact = "Facilities Management Team"
}

# Link HVAC to Datacenter Operations
resource "pagerduty_service_dependency" "hvac_to_datacenter_ops" {
  dependency {
    dependent_service {
      id   = pagerduty_business_service.datacenter_operations.id
      type = "business_service"
    }
    supporting_service {
      id   = pagerduty_service.hvac_cooling.id
      type = "service"
    }
  }
}

# Link Power & Electrical to Datacenter Operations
resource "pagerduty_service_dependency" "power_to_datacenter_ops" {
  dependency {
    dependent_service {
      id   = pagerduty_business_service.datacenter_operations.id
      type = "business_service"
    }
    supporting_service {
      id   = pagerduty_service.power_electrical.id
      type = "service"
    }
  }
}

# Link Environmental Monitoring to Datacenter Operations
resource "pagerduty_service_dependency" "environmental_to_datacenter_ops" {
  dependency {
    dependent_service {
      id   = pagerduty_business_service.datacenter_operations.id
      type = "business_service"
    }
    supporting_service {
      id   = pagerduty_service.environmental_monitoring.id
      type = "service"
    }
  }
}

# Business Service 2: Datacenter Security & Safety
resource "pagerduty_business_service" "security_and_safety" {
  name             = "Datacenter Security & Safety"
  description      = "Physical security and life safety systems"
  point_of_contact = "Security & Safety Team"
}

# Link Physical Security to Security & Safety
resource "pagerduty_service_dependency" "security_to_security_safety" {
  dependency {
    dependent_service {
      id   = pagerduty_business_service.security_and_safety.id
      type = "business_service"
    }
    supporting_service {
      id   = pagerduty_service.physical_security.id
      type = "service"
    }
  }
}

# Link Fire Safety to Security & Safety
resource "pagerduty_service_dependency" "fire_to_security_safety" {
  dependency {
    dependent_service {
      id   = pagerduty_business_service.security_and_safety.id
      type = "business_service"
    }
    supporting_service {
      id   = pagerduty_service.fire_safety.id
      type = "service"
    }
  }
}

# Business Service 3: IT Infrastructure Connectivity
resource "pagerduty_business_service" "it_connectivity" {
  name             = "IT Infrastructure Connectivity"
  description      = "Network and connectivity services for customer equipment"
  point_of_contact = "Network Operations Team"
}

# Link Network Infrastructure to IT Connectivity
resource "pagerduty_service_dependency" "network_to_it_connectivity" {
  dependency {
    dependent_service {
      id   = pagerduty_business_service.it_connectivity.id
      type = "business_service"
    }
    supporting_service {
      id   = pagerduty_service.network_infrastructure.id
      type = "service"
    }
  }
}

# Outputs for reference
output "business_service_datacenter_operations_id" {
  value       = pagerduty_business_service.datacenter_operations.id
  description = "ID of Datacenter Operations business service"
}

output "business_service_security_and_safety_id" {
  value       = pagerduty_business_service.security_and_safety.id
  description = "ID of Datacenter Security & Safety business service"
}

output "business_service_it_connectivity_id" {
  value       = pagerduty_business_service.it_connectivity.id
  description = "ID of IT Infrastructure Connectivity business service"
}
