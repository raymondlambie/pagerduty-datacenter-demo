# PagerDuty Datacenter Demo - Sydney

Terraform configuration for a complete PagerDuty demo showcasing datacenter BMS (Building Management System) integration with Niagara format alerts.

## 🏢 Overview

This demo simulates a datacenter in **Sydney, Australia** with 6 critical infrastructure services monitored by a Niagara BMS system. Alerts are routed to specialized response teams based on severity and system type.

## 🎯 Features

- **6 Services**: Power, HVAC, Environmental, Security, Fire Safety, Network
- **4 Teams**: Infrastructure, Environmental, Security, Life Safety
- **6 Escalation Policies**: Tailored escalation with dual notification for critical systems
- **7 Schedules**: 24/7 coverage in Australia/Sydney timezone
- **Event Orchestrations**: Automatic severity mapping (critical→P1, error→P2, warning→P3, info→P4)
- **Location Prefix**: Alerts with location data show as `[Location] Summary`
- **MS Teams Integration**: Incident notifications via Microsoft Teams
- **3 Response Plays**: Power Outage, Fire Alarm, Security Breach

## 📋 Prerequisites

- Terraform >= 1.0
- PagerDuty account with API access
- PagerDuty API token with full access permissions

## 🔑 Getting Your API Token

1. Log into PagerDuty
2. Navigate to **Integrations** → **API Access Keys**
3. Click **Create New API Key**
4. Name it (e.g., "Terraform Demo")
5. Copy the token immediately (shown only once)

## 🚀 Quick Start

### 1. Configure API Token

**Option A: Environment Variable (Recommended)**
```bash
export PAGERDUTY_TOKEN="your-api-token-here"
```

**Option B: Edit terraform.tfvars**
```bash
# Edit terraform.tfvars and add:
pagerduty_token = "your-api-token-here"
```

### 2. Customize Variables (Optional)

Edit `terraform.tfvars` to customize:
- User emails (must not already exist in PagerDuty)
- MS Teams channel URL
- Conference bridge URL
- Timezone (default: Australia/Sydney)

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Preview Changes

```bash
terraform plan
```

### 5. Deploy

```bash
terraform apply
```

Type `yes` when prompted.

## 📁 File Structure

```
.
├── main.tf                    # Provider configuration
├── variables.tf               # Variable definitions
├── terraform.tfvars           # Your configuration values
├── users.tf                   # 15 demo users
├── teams.tf                   # 4 response teams
├── schedules.tf               # 7 on-call schedules (Sydney timezone)
├── escalation_policies.tf     # 6 escalation policies
├── services.tf                # 6 monitored services
├── priorities.tf              # P1-P4 priority references
├── event_orchestrations.tf    # Severity mapping & location prefix
├── outputs.tf                 # Integration keys & service IDs
├── .gitignore                 # Excludes sensitive files
└── README.md                  # This file
```

## 🎬 Demo Scenarios

### Scenario 1: Critical Power Alert
```bash
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "<power_integration_key>",
    "event_action": "trigger",
    "payload": {
      "summary": "UPS Battery Low - 5 minutes remaining",
      "severity": "critical",
      "source": "Niagara BMS",
      "custom_details": {
        "location": "Sydney DC - Floor 3",
        "system": "UPS-A",
        "battery_level": "15%"
      }
    }
  }'
```

**Result**: 
- Creates P1 incident
- Title: `[Sydney DC - Floor 3] UPS Battery Low - 5 minutes remaining`
- Escalates to Infrastructure Team
- Dual notification (push + SMS)

### Scenario 2: HVAC Warning
```bash
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "<hvac_integration_key>",
    "event_action": "trigger",
    "payload": {
      "summary": "Temperature rising in Server Room",
      "severity": "warning",
      "source": "Niagara BMS",
      "custom_details": {
        "location": "Sydney DC - Server Room 2",
        "temperature": "28°C",
        "threshold": "25°C"
      }
    }
  }'
```

**Result**:
- Creates P3 incident
- Title: `[Sydney DC - Server Room 2] Temperature rising in Server Room`
- Routes to Environmental Team
- 5-minute escalation

### Scenario 3: Fire Alarm
```bash
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "<fire_safety_integration_key>",
    "event_action": "trigger",
    "payload": {
      "summary": "Smoke Detector Activated",
      "severity": "critical",
      "source": "Niagara BMS",
      "custom_details": {
        "location": "Sydney DC - Electrical Room",
        "detector_id": "SD-42",
        "zone": "Zone 3"
      }
    }
  }'
```

**Result**:
- Creates P1 incident
- Title: `[Sydney DC - Electrical Room] Smoke Detector Activated`
- Triggers "Fire Alarm Response" play
- Immediate dual notification to Life Safety team

## 🔧 Event Orchestration Logic

Each service has 8 orchestration rules:

### With Location Data
1. **Critical + Location** → P1 + `[Location] Summary`
2. **Error + Location** → P2 + `[Location] Summary`
3. **Warning + Location** → P3 + `[Location] Summary`
4. **Info + Location** → P4 + `[Location] Summary`

### Without Location Data
5. **Critical** → P1
6. **Error** → P2
7. **Warning** → P3
8. **Info** → P4

## 📊 Services & Teams

| Service | Team | Escalation Policy | Response Time |
|---------|------|-------------------|---------------|
| Power & Electrical | Infrastructure | Critical Infrastructure | 1 min → 3 min → 5 min |
| HVAC & Cooling | Environmental | Environmental Systems | 1 min → 5 min → 10 min |
| Environmental Monitoring | Environmental | Environmental Systems | 1 min → 5 min → 10 min |
| Physical Security | Security | Security Response | 1 min → 3 min → 5 min |
| Fire Safety | Life Safety | Life Safety Critical | 1 min → 2 min → 3 min (9 loops) |
| Network Infrastructure | Infrastructure | Critical Infrastructure | 1 min → 3 min → 5 min |

## 🕐 Schedules (Australia/Sydney Timezone)

- **Primary On-Call**: 24/7 rotation (weekly)
- **Secondary On-Call**: 24/7 backup
- **Business Hours**: Mon-Fri 9am-5pm
- **After Hours**: Mon-Fri 5pm-9am + Weekends
- **Weekend Coverage**: Sat-Sun 24h
- **Manager Escalation**: Business hours only
- **Executive Escalation**: 24/7 (critical only)

## 🔐 Security Notes

- **Never commit** `terraform.tfvars` with real API tokens
- Use environment variables for sensitive data
- `.gitignore` is configured to exclude sensitive files
- Rotate API tokens regularly

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted.

## 📝 Customization

### Add More Users
Edit `users.tf` and add:
```hcl
resource "pagerduty_user" "new_user" {
  name  = "New User"
  email = "newuser@example.com"
  role  = "user"
}
```

### Modify Schedules
Edit `schedules.tf` to adjust:
- Rotation frequency
- Time zones
- Coverage hours

### Change Escalation Timing
Edit `escalation_policies.tf` to adjust:
- `escalation_delay_in_minutes`
- `num_loops` (1-9)

### Add Custom Orchestration Rules
Edit `event_orchestrations.tf` to add custom logic for:
- Additional severity levels
- Custom field extraction
- Advanced routing logic

## 🐛 Troubleshooting

### "License error: Unable to perform request"
- Your PagerDuty account has reached the user limit
- Reduce the number of users in `users.tf`
- Or upgrade your PagerDuty plan

### "User email already exists"
- Change email addresses in `terraform.tfvars`
- Ensure emails are unique and not already in PagerDuty

### "Invalid API token"
- Verify token has full access permissions
- Check token hasn't expired
- Ensure no extra spaces in token string

### "Priority not found"
- Priorities (P1-P4) must exist in your PagerDuty account
- Create them manually or adjust `priorities.tf`

## 📚 Resources

- [PagerDuty Terraform Provider](https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs)
- [PagerDuty Events API v2](https://developer.pagerduty.com/docs/ZG9jOjExMDI5NTgw-events-api-v2-overview)
- [Event Orchestrations](https://support.pagerduty.com/docs/event-orchestration)
- [Niagara BMS Integration](https://support.pagerduty.com/docs/niagara-integration-guide)

## 📧 Support

For issues with this demo configuration, please review the troubleshooting section above.

---

**Version**: 2.0  
**Last Updated**: March 2026  
**Timezone**: Australia/Sydney (UTC+11)  
**Notification**: MS Teams
