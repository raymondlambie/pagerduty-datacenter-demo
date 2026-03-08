# PagerDuty Datacenter Demo - Niagara BMS Integration

Complete PagerDuty configuration for datacenter Building Management System (BMS) alert integration, designed for demo and production use in Sydney, Australia.

## ⚠️ TODO - Remaining Configuration Items

### 1. MS Teams Integration Setup
**Status**: App installed, channels need configuration  
**Priority**: High  
**Description**: Configure MS Teams channels to receive PagerDuty incident notifications using the official PagerDuty app.

**Steps Required**:
1. Create MS Teams channels for incident notifications
2. Add PagerDuty app to each channel
3. Configure notification routing in PagerDuty web UI
4. Test incident notifications

See [MS Teams Integration Guide](#ms-teams-integration-setup) below for detailed instructions.

### 2. CMMS Integration Demo
**Status**: Not configured  
**Priority**: Medium  
**Description**: Demonstrate integration between PagerDuty incidents and Computerized Maintenance Management System (CMMS) for work order creation.

**Options to Explore**:
- Webhook-based integration (PagerDuty → CMMS)
- Bi-directional sync using PagerDuty API
- Demo using mock CMMS endpoints
- Integration with popular CMMS platforms (ServiceNow, Maximo, etc.)

**Deliverables**:
- Sample integration script or workflow
- Demo scenario showing incident → work order flow
- Documentation for CMMS integration patterns

---

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
- **MS Teams Integration**: Native app integration with interactive incident cards
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
- MS Teams workspace with admin permissions
- PagerDuty app for MS Teams (installed)

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
- Conference bridge URL
- Timezone (default: Australia/Sydney)

### 4. Deploy
```bash
terraform init
terraform plan
terraform apply
```

### 5. Configure MS Teams Integration
See [MS Teams Integration Guide](#ms-teams-integration-setup) below.

### 6. Verify
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

## MS Teams Integration Setup

### Overview
The official PagerDuty app for MS Teams provides native integration with interactive incident cards, real-time updates, and the ability to acknowledge/resolve incidents directly from Teams.

**✅ Benefits over webhooks:**
- Interactive incident cards with action buttons
- Real-time status updates as incidents change
- Trigger incidents directly from Teams
- View on-call schedules without leaving Teams
- No webhook expiration issues
- Richer formatting and context

### Prerequisites
- PagerDuty app for MS Teams installed (✅ Already done)
- MS Teams admin permissions to add apps to channels
- PagerDuty account with admin access

---

### Step 1: Create MS Teams Channels

Create dedicated channels in your MS Teams workspace for incident notifications:

**Recommended Channel Structure:**

```
📱 Datacenter Operations Team
├─ 🚨 #pagerduty-critical (P1/P2 incidents only - all services)
├─ 🔧 #pagerduty-infrastructure (Power, Network)
├─ 🌡️ #pagerduty-environmental (HVAC, Environmental)
└─ 🔒 #pagerduty-security (Security, Fire Safety)
```

**Alternative (Simpler):**
```
📱 Datacenter Operations Team
└─ 🚨 #pagerduty-incidents (All incidents)
```

To create channels:
1. Go to your MS Teams workspace
2. Click **"..."** next to your team name
3. Select **"Add channel"**
4. Name the channel (e.g., "pagerduty-critical")
5. Set privacy to **"Standard"** (or Private if needed)
6. Click **"Add"**

---

### Step 2: Add PagerDuty App to Channels

For each channel you created:

1. **Open the channel** in MS Teams
2. **Click the "+" tab** at the top of the channel
3. **Search for "PagerDuty"** in the app list
4. **Click "PagerDuty"** and then **"Add"**
5. **Authenticate** with your PagerDuty account (if prompted)
6. **Configure the tab**:
   - Choose what to display (e.g., "Incidents", "On-Call Schedule")
   - Click **"Save"**

Repeat for all channels.

---

### Step 3: Configure Notification Routing in PagerDuty

Now configure which incidents go to which Teams channels:

1. **Log into PagerDuty** web interface
2. **Go to**: **Integrations → Microsoft Teams**
3. **Click "Connect"** or **"Configure"** (if not already connected)
4. **Authenticate** with your MS Teams account
5. **Configure notification routing**:

#### Option A: Multi-Channel Setup (Recommended for Demo)

**#pagerduty-critical** (High-priority incidents only)
- Services: All 6 services
- Priority filter: **P1 and P2 only**
- Notifications:
  - ✅ Incident triggered
  - ✅ Incident escalated
  - ✅ Incident acknowledged
  - ✅ Incident resolved

**#pagerduty-infrastructure**
- Services: 
  - Power & Electrical
  - Network Infrastructure
- Priority filter: All priorities
- Notifications: All incident events

**#pagerduty-environmental**
- Services:
  - HVAC & Cooling
  - Environmental Monitoring
- Priority filter: All priorities
- Notifications: All incident events

**#pagerduty-security**
- Services:
  - Physical Security
  - Fire Safety
- Priority filter: All priorities
- Notifications: All incident events

#### Option B: Single Channel Setup (Simpler)

**#pagerduty-incidents**
- Services: All 6 services
- Priority filter: All priorities
- Notifications: All incident events

---

### Step 4: Configure Notification Preferences

In the PagerDuty MS Teams integration settings:

1. **Notification Events** - Choose which events trigger notifications:
   - ✅ Incident triggered
   - ✅ Incident acknowledged
   - ✅ Incident escalated
   - ✅ Incident resolved
   - ⬜ Incident reassigned (optional)
   - ⬜ Incident priority changed (optional)

2. **@Mentions** - Configure automatic mentions:
   - ✅ @mention assigned responder when incident triggers
   - ✅ @mention escalation target when incident escalates
   - ⬜ @mention entire channel for P1 incidents (optional)

3. **Incident Details** - Choose what information to display:
   - ✅ Service name
   - ✅ Priority
   - ✅ Assigned responder
   - ✅ Custom fields (from event orchestrations)
   - ✅ Alert count

4. **Click "Save"**

---

### Step 5: Test the Integration

Send a test alert to verify MS Teams notifications:

```bash
# Get your integration key from terraform output
terraform output power_electrical_integration_key

# Send test alert
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "YOUR_INTEGRATION_KEY",
    "event_action": "trigger",
    "payload": {
      "summary": "TEST: MS Teams Integration Check",
      "source": "test-system",
      "severity": "warning",
      "custom_details": {
        "location": "Sydney Datacenter",
        "test": "true"
      }
    }
  }'
```

**Expected Result:**
- Incident card appears in the configured MS Teams channel(s)
- Card shows incident details, priority, and assigned responder
- Action buttons available: "Acknowledge", "Resolve", "View in PagerDuty"

---

### Step 6: Interact with Incidents from Teams

Once configured, you can:

**Acknowledge an Incident:**
1. Click **"Acknowledge"** button on the incident card
2. Incident status updates in real-time
3. Card shows who acknowledged and when

**Resolve an Incident:**
1. Click **"Resolve"** button on the incident card
2. Optionally add resolution notes
3. Incident closes and card updates

**View Incident Details:**
1. Click **"View in PagerDuty"** button
2. Opens incident in PagerDuty web UI

**Trigger New Incident:**
1. Type `/pagerduty trigger` in any channel
2. Fill in incident details
3. Select service and priority
4. Submit to create incident

**Check On-Call Schedule:**
1. Type `/pagerduty oncall` in any channel
2. View current on-call responders for all teams

---

### MS Teams Integration Architecture

```
Niagara BMS Alert
       ↓
PagerDuty Event API
       ↓
Event Orchestration (routing, enrichment)
       ↓
Service (with alert grouping)
       ↓
Incident Created
       ↓
MS Teams App (native integration)
       ↓
Teams Channel Notification
       ↓
Interactive Incident Card
       ↓
Responder Actions (Ack/Resolve from Teams)
```

---

### Troubleshooting MS Teams Integration

**Not receiving notifications in Teams?**
- Verify PagerDuty app is added to the channel (check tabs)
- Check notification routing in PagerDuty → Integrations → MS Teams
- Ensure services are mapped to the correct channels
- Verify priority filters aren't blocking incidents
- Check Teams notification settings (not muted)

**Can't authenticate PagerDuty app?**
- Ensure you have admin permissions in PagerDuty
- Try disconnecting and reconnecting the integration
- Clear Teams cache and restart

**Incident cards not updating?**
- Check PagerDuty app permissions in MS Teams admin center
- Verify webhook connectivity (PagerDuty → MS Teams)
- Try removing and re-adding the app to the channel

**Action buttons not working?**
- Ensure you're logged into PagerDuty in the Teams app
- Check user permissions in PagerDuty (must be able to manage incidents)
- Try re-authenticating the PagerDuty app

**App not showing in Teams?**
- Check if PagerDuty app is approved in your MS Teams admin center
- Contact your Teams admin to enable the app
- Verify your organization allows third-party apps

---

### Advanced: Custom Incident Cards

The PagerDuty app automatically formats incident cards with:
- **Title**: Incident summary
- **Priority badge**: Color-coded (Red=P1, Orange=P2, Yellow=P3, Gray=P4)
- **Service name**: Which service triggered the incident
- **Assigned responder**: Who's handling it
- **Custom fields**: Extracted by event orchestrations (e.g., location, unit_id)
- **Alert count**: Number of grouped alerts
- **Timestamps**: When triggered, acknowledged, resolved
- **Action buttons**: Acknowledge, Resolve, View in PagerDuty

Custom fields from your event orchestrations will automatically appear:
- `location` (e.g., "Sydney Datacenter - Server Room A")
- `unit_id` (e.g., "CRAC-03")
- `equipment_type` (e.g., "UPS", "Chiller")
- `sensor_location` (e.g., "Row 5, Rack 12")

---

### Conference Bridge Integration

The `conference_bridge_url` in `terraform.tfvars` is still useful for:
- Adding MS Teams meeting links to incidents
- Automatic conference bridge creation for P1 incidents
- Quick access to team communication during major incidents

**To use MS Teams meetings as conference bridges:**

1. Create a dedicated MS Teams meeting for incident response
2. Get the meeting URL (e.g., `https://teams.microsoft.com/l/meetup-join/...`)
3. Update `terraform.tfvars`:
   ```hcl
   conference_bridge_url = "https://teams.microsoft.com/l/meetup-join/YOUR_MEETING_ID"
   ```
4. Run `terraform apply`

This URL will be included in incident details for quick access to the war room.

---

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
        "threshold": "25°C",
        "location": "Sydney DC - Server Room A"
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
# Notification appears in #pagerduty-critical and #pagerduty-environmental
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "<environmental_integration_key>",
    "event_action": "trigger",
    "payload": {
      "summary": "Water detected in Server Room A",
      "source": "WATER-SENSOR-A-01",
      "severity": "error",
      "custom_details": {
        "location": "Sydney DC - Server Room A - Row 5"
      }
    }
  }'
```

### 2. CRAC Unit Failure
```bash
# Critical cooling failure
# Notification appears in #pagerduty-critical and #pagerduty-environmental
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "<hvac_integration_key>",
    "event_action": "trigger",
    "payload": {
      "summary": "CRAC Unit 3 Compressor Failure",
      "source": "CRAC-03",
      "severity": "critical",
      "custom_details": {
        "unit_id": "CRAC-03",
        "location": "Sydney DC - Cooling Plant"
      }
    }
  }'
```

### 3. Core Network Outage
```bash
# Core switch failure affecting multiple systems
# Notification appears in #pagerduty-critical and #pagerduty-infrastructure
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "<network_integration_key>",
    "event_action": "trigger",
    "payload": {
      "summary": "Core Switch Offline",
      "source": "SWITCH-CORE-DC1-01",
      "severity": "critical",
      "custom_details": {
        "device_location": "Sydney DC - MDF Room",
        "affected_systems": "All server racks"
      }
    }
  }'
```

### 4. Demonstrate MS Teams Interaction
```bash
# Send a test incident, then:
# 1. View the incident card in Teams
# 2. Click "Acknowledge" button
# 3. Add notes in PagerDuty
# 4. Click "Resolve" button from Teams
# 5. Watch the card update in real-time
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
7. **MS Teams Channels**: Use dedicated channels for different priority levels
8. **Test Interactions**: Regularly test acknowledge/resolve from Teams

## Support

For PagerDuty-specific questions:
- [PagerDuty Documentation](https://support.pagerduty.com/)
- [Terraform PagerDuty Provider](https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs)
- [MS Teams Integration Guide](https://support.pagerduty.com/docs/microsoft-teams)

## License

This configuration is provided as-is for demonstration purposes.

## Contributors

Created for datacenter BMS integration demo - Sydney, Australia
