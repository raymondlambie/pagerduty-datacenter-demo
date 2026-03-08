# PagerDuty Datacenter Demo - Niagara BMS Integration

Complete PagerDuty configuration for datacenter Building Management System (BMS) alert integration, designed for demo and production use in Sydney, Australia.

## Overview

This Terraform configuration creates a complete PagerDuty setup for managing datacenter infrastructure alerts from Niagara BMS systems. It includes intelligent alert routing, escalation policies, on-call schedules, and event orchestrations tailored for critical datacenter operations.

## Features

- **6 Service Categories**: Power/Electrical, HVAC/Cooling, Environmental, Physical Security, Fire Safety, Network Infrastructure
- **4 Response Teams**: Infrastructure, Environmental, Security, Life Safety
- **15 Demo Users**: Pre-configured with realistic roles and contact methods
- **7 On-Call Schedules**: 24/7 coverage with Australia/Sydney timezone
- **6 Escalation Policies**: Tiered response with dual notification (phone + SMS for critical alerts)
- **Advanced Event Orchestrations**: 
  - Water leak detection with immediate escalation
  - Maintenance window suppression
  - Critical equipment pattern matching (UPS, CRAC, Chiller, Core Network)
  - Intelligent severity mapping from Niagara BMS
  - Custom field extraction for troubleshooting
- **MS Teams Integration**: Incident notifications and conference bridge
- **Intelligent Alert Grouping**: Reduces alert fatigue

## Architecture

### Services
- **Power & Electrical** → Critical Infrastructure Team
- **HVAC & Cooling** → Environmental Systems Team
- **Environmental Monitoring** → Environmental Systems Team
- **Physical Security** → Security Response Team
- **Fire Safety** → Life Safety Team
- **Network Infrastructure** → Critical Infrastructure Team

### Escalation Flow
1. **Primary On-Call** (immediate notification via phone + SMS for P1/P2)
2. **Secondary On-Call** (escalation after 5-15 minutes)
3. **Team Lead** (final escalation)
4. **Repeat** up to 9 times for life safety critical alerts

## Prerequisites

- Terraform >= 1.0
- PagerDuty account (trial or paid)
- PagerDuty API token with full access
- User emails must not already exist in your PagerDuty account

## Quick Start

### 1. Clone Repository
```bash
git clone <your-repo-url>
cd pagerduty-datacenter-demo
```

### 2. Configure API Token
```bash
export PAGERDUTY_TOKEN="your-api-token-here"
```

Or edit `terraform.tfvars`:
```hcl
pagerduty_token = "your-api-token-here"
```

**⚠️ Security Warning**: Never commit your API token to version control!

### 3. Customize Variables (Optional)
Edit `terraform.tfvars` to customize:
- User emails (must be unique in your PagerDuty account)
- MS Teams channel URL
- Conference bridge URL
- Timezone (default: Australia/Sydney)

### 4. Deploy
```bash
terraform init
terraform plan
terraform apply
```

### 5. Verify
After deployment, check the outputs for integration keys:
```bash
terraform output
```

## Configuration Files

| File | Purpose |
|------|---------|
| `main.tf` | Provider configuration and priority data sources |
| `variables.tf` | Variable definitions |
| `terraform.tfvars` | Variable values (customize this) |
| `users.tf` | 15 demo users with contact methods |
| `teams.tf` | 4 response teams with memberships |
| `schedules.tf` | 7 on-call schedules (24/7 coverage) |
| `escalation_policies.tf` | 6 escalation policies with dual notification |
| `services.tf` | 6 services with alert grouping |
| `event_orchestrations.tf` | Advanced alert routing and enrichment |
| `outputs.tf` | Integration keys and service IDs |

## Event Orchestration Rules

### Power & Electrical
- ✅ UPS/PDU/Generator failures → P1 Critical
- ✅ Maintenance suppression

### HVAC & Cooling
- ✅ HVAC/CRAC failures → P1 Critical with unit ID extraction
- ✅ Chiller alerts with monitoring
- ✅ Maintenance suppression

### Environmental Monitoring
- ✅ **Water leak detection** → Immediate P1 escalation
- ✅ Critical temperature alerts with sensor location extraction
- ✅ Standard temp/humidity monitoring
- ✅ Maintenance suppression

### Physical Security
- ✅ All critical/error alerts → P1
- ✅ Maintenance suppression

### Network Infrastructure
- ✅ Core network failures → P1 with device location extraction
- ✅ Access switch issues → P3 (lower priority)
- ✅ Info alert suppression
- ✅ Maintenance suppression

### Fire Safety
- ✅ Standard severity mapping (Critical → P1, Error → P2, etc.)

## Niagara BMS Integration

### Sending Alerts to PagerDuty

Use the integration keys from `terraform output` to send events:

```bash
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "<integration_key>",
    "event_action": "trigger",
    "payload": {
      "summary": "HVAC-CRAC-01 Temperature Critical",
      "source": "HVAC-CRAC-01",
      "severity": "critical",
      "custom_details": {
        "component": "Temperature",
        "value": "35°C",
        "threshold": "25°C"
      }
    }
  }'
```

### Severity Mapping
| Niagara Severity | PagerDuty Priority | Response Time |
|------------------|-------------------|---------------|
| `critical` | P1 - Critical | Immediate (phone + SMS) |
| `error` | P2 - High | 5 minutes |
| `warning` | P3 - Low | 15 minutes |
| `info` | P4 - Low | 30 minutes |

### Maintenance Mode
Suppress alerts during maintenance by including:
```json
{
  "custom_details": {
    "maintenance_mode": "true"
  }
}
```
Or include `[MAINTENANCE]` in the summary.

## Demo Scenarios

### 1. Water Leak Emergency
```bash
# Triggers immediate P1 escalation to Environmental team
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "<environmental_integration_key>",
    "event_action": "trigger",
    "payload": {
      "summary": "Water detected in Server Room A",
      "source": "WATER-SENSOR-A-01",
      "severity": "error"
    }
  }'
```

### 2. CRAC Unit Failure
```bash
# Critical cooling failure
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "<hvac_integration_key>",
    "event_action": "trigger",
    "payload": {
      "summary": "CRAC Unit 3 Compressor Failure",
      "source": "CRAC-03",
      "severity": "critical"
    }
  }'
```

### 3. Core Network Outage
```bash
# Core switch failure affecting multiple systems
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "<network_integration_key>",
    "event_action": "trigger",
    "payload": {
      "summary": "Core Switch Offline",
      "source": "SWITCH-CORE-DC1-01",
      "severity": "critical"
    }
  }'
```

## Customization

### Adding Users
Edit `users.tf` and add:
```hcl
resource "pagerduty_user" "new_user" {
  name  = "New User"
  email = "newuser@example.com"
  role  = "user"
}

resource "pagerduty_user_contact_method" "new_user_phone" {
  user_id = pagerduty_user.new_user.id
  type    = "phone_contact_method"
  address = "+61412345678"
  label   = "Mobile"
}
```

### Modifying Schedules
Edit `schedules.tf` to adjust:
- Coverage hours
- Rotation frequency
- Timezone
- On-call assignments

### Adjusting Escalation Timing
Edit `escalation_policies.tf`:
```hcl
escalation_delay_in_minutes = 10  # Change from 5 to 10 minutes
```

## Maintenance

### Updating Configuration
```bash
# Make changes to .tf files
terraform plan    # Review changes
terraform apply   # Apply changes
```

### Destroying Resources
```bash
terraform destroy
```

**⚠️ Warning**: This will delete all PagerDuty resources created by this configuration!

## Troubleshooting

### User Already Exists Error
If you see "License error: Unable to perform request", the user email already exists in PagerDuty. Either:
1. Use different email addresses in `terraform.tfvars`
2. Remove existing users from PagerDuty first
3. Import existing users instead of creating new ones

### Escalation Delay Error
Ensure `escalation_delay_in_minutes` is at least 1 in all escalation policies.

### Alert Grouping Errors
For intelligent grouping, ensure the `config {}` block is present in `services.tf`.

## Best Practices

1. **Test Before Production**: Use a PagerDuty trial account for testing
2. **Secure API Tokens**: Use environment variables, never commit tokens
3. **Version Control**: Track all changes in git
4. **Review Plans**: Always run `terraform plan` before `apply`
5. **Backup State**: Store `terraform.tfstate` securely (use remote backend)
6. **Document Changes**: Update this README when modifying configuration

## Support

For PagerDuty-specific questions:
- [PagerDuty Documentation](https://support.pagerduty.com/)
- [Terraform PagerDuty Provider](https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs)

## License

This configuration is provided as-is for demonstration purposes.

## Contributors

Created for datacenter BMS integration demo - Sydney, Australia
