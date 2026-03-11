# PagerDuty Datacenter Demo - Complete Evaluation Kit

A comprehensive, ready-to-deploy PagerDuty configuration showcasing end-to-end incident management for datacenter operations. Perfect for evaluating PagerDuty's capabilities during your trial period.

## 🎯 What This Demo Provides

This repository contains a **complete, working PagerDuty environment** that demonstrates:

- **BMS Integration**: Niagara-format alert ingestion from Building Management Systems
- **Intelligent Alert Processing**: Automatic grouping, severity mapping, and priority assignment
- **Automated Workflows**: MS Teams integration, structured updates, and CMMS ticketing
- **AI-Powered Response**: SRE Agent with runbook recommendations (requires AI Ops)
- **Stakeholder Communications**: Internal/external status pages with approval workflows
- **Real-World Scenarios**: 6 datacenter services with realistic alert examples

**Perfect for**: Datacenter operators, facilities managers, and infrastructure teams evaluating PagerDuty for critical infrastructure monitoring.

---

## 🏢 Demo Environment Overview

### What Gets Created

**6 Critical Infrastructure Services:**
- Power & Electrical Systems
- HVAC & Cooling
- Environmental Monitoring
- Physical Security
- Fire Safety Systems
- Network Infrastructure

**4 Specialized Response Teams:**
- Infrastructure Team
- Environmental Team
- Security Team
- Life Safety Team

**15 Demo Users** with realistic roles and on-call schedules

**7 On-Call Schedules** providing 24/7 coverage (Australia/Sydney timezone)

**Automated Workflows** including:
- MS Teams incident chat creation
- Structured update prompts (system-specific)
- CMMS work order creation
- Conference bridge setup
- Status page updates

**Business Services** mapped to technical services for impact visibility

---

## 🚀 Getting Started (No Terraform Experience Required)

### Step 1: Install Terraform

**Mac (using Homebrew):**
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Windows (using Chocolatey):**
```bash
choco install terraform
```

**Linux (Ubuntu/Debian):**
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Verify installation:**
```bash
terraform --version
```

### Step 2: Get Your PagerDuty API Token

1. Log into your PagerDuty trial account
2. Click your profile icon (top right) → **My Profile**
3. Go to the **User Settings** tab
4. Scroll to **API Access** section
5. Click **Create API User Token**
6. Give it a name: "Terraform Demo"
7. **Copy the token immediately** (it's only shown once!)

### Step 3: Download This Repository

**Option A: Using Git**
```bash
git clone https://github.com/raymondlambie/pagerduty-datacenter-demo.git
cd pagerduty-datacenter-demo
```

**Option B: Download ZIP**
1. Click the green "Code" button on GitHub
2. Select "Download ZIP"
3. Extract the ZIP file
4. Open terminal/command prompt in the extracted folder

### Step 4: Configure Your Settings

Create a file called `terraform.tfvars` in the repository folder:

```bash
# Copy the example file
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and add your settings:

```hcl
# Required: Your PagerDuty API token
pagerduty_token = "your-api-token-here"

# Optional: Customize user emails (must be unique, not already in PagerDuty)
# Leave as-is to use demo emails like user1@example.com, user2@example.com, etc.

# Optional: MS Teams webhook URL (if you have one)
# msteams_webhook_url = "https://your-teams-webhook-url"

# Optional: Conference bridge URL
# conference_bridge_url = "https://zoom.us/j/your-meeting-id"
```

**Important**: The demo creates 15 users. If you want to use real email addresses, update them in `terraform.tfvars`. Otherwise, the demo uses placeholder emails.

### Step 5: Deploy the Demo

**Initialize Terraform** (downloads required plugins):
```bash
terraform init
```

**Preview what will be created** (optional but recommended):
```bash
terraform plan
```

**Deploy the demo**:
```bash
terraform apply
```

Type `yes` when prompted.

**Deployment takes 2-3 minutes.** You'll see output showing integration keys and service IDs.

### Step 6: Install PagerDuty App in Microsoft Teams

**This demo is designed to work with the PagerDuty app in MS Teams.** Install it now for the best experience.

#### 6.1 Install the PagerDuty App

1. **Open Microsoft Teams**
2. Click **Apps** in the left sidebar (or click the "..." menu and select "Apps")
3. In the search box, type **"PagerDuty"**
4. Click on the **PagerDuty** app from the search results
5. Click **Add** button
   - If prompted, choose **Add for me** (personal app) or **Add to a team** (team channel)
   - **Recommended**: Add for yourself first to test

#### 6.2 Connect PagerDuty to Your Trial Account

1. **In MS Teams**, find the PagerDuty app:
   - Look in your left sidebar under **Apps** or **More added apps** (...)
   - Or search for "PagerDuty" in the top search bar and select the app
2. Click **Sign In** or **Connect Account** button
3. You'll be redirected to PagerDuty in your browser
4. **Sign in with your trial account credentials**
5. Review the permissions and click **Authorize** or **Allow**
6. You'll be redirected back to Teams
7. You should see a success message: **"Successfully connected to PagerDuty!"**

#### 6.3 Configure Your Notification Preferences

1. In the PagerDuty app in Teams, click the **Settings** tab (or gear icon)
2. **Enable notifications** for:
   - ✅ **Incidents assigned to me**
   - ✅ **Incidents escalated to me**
   - ✅ **High-urgency incidents**
   - ✅ **Incident updates and notes**
   - ✅ **Incident acknowledgments and resolves**
3. **Choose notification style**:
   - **Recommended**: **Banner + Feed** (you'll see pop-ups and a notification feed)
   - Alternative: **Feed only** (quieter, check the app for updates)
4. **Set your status sync** (optional):
   - ✅ **Update my Teams status when I'm on-call** (shows "On-call" in Teams)
   - ✅ **Update my Teams status during active incidents** (shows "In a call" or "Busy")

#### 6.4 Test the Connection

**Test 1: Check On-Call Status**
1. In MS Teams, go to any chat or the PagerDuty app
2. Type `/pagerduty oncall` and press Enter
3. You should see a list of who's currently on-call for each service
4. ✅ **Success**: You see on-call schedules

**Test 2: View Your Incidents**
1. In the PagerDuty app in Teams, click the **Incidents** tab
2. You should see any open incidents (none yet if you haven't sent alerts)
3. ✅ **Success**: The incidents list loads

**Test 3: Use PagerDuty Commands**
1. In any Teams chat, type `/pagerduty` and press Space
2. You should see available commands:
   - `/pagerduty oncall` - See who's on-call
   - `/pagerduty trigger` - Create a new incident
   - `/pagerduty ack` - Acknowledge an incident
   - `/pagerduty resolve` - Resolve an incident
3. ✅ **Success**: Commands are available

**You're now ready to receive PagerDuty incidents directly in MS Teams!** 🎉

#### 6.5 Add PagerDuty to a Team Channel (Optional)

If you want incident notifications in a specific Teams channel:

1. Go to the team channel where you want PagerDuty notifications
2. Click the **+** (plus) icon at the top of the channel
3. Search for **PagerDuty** and select it
4. Click **Add**
5. Configure which incidents to show in this channel:
   - **All incidents** (noisy, not recommended)
   - **High-urgency incidents only** (recommended)
   - **Specific services** (select your critical services)
6. Click **Save**

**Recommended setup**: Add PagerDuty to an **"Incidents"** or **"Operations"** channel for team visibility.

### Step 7: Save Your Integration Keys

After deployment completes, you'll see output like:
```
Outputs:

power_integration_key = "abc123..."
hvac_integration_key = "def456..."
...
```

**Save these keys!** You'll need them to send test alerts.

---

## 🎬 Try It Out: Send Your First Alert

### Using the Interactive HTML Demo

1. Open `pagerduty-datacenter-demo.html` in your web browser
2. Paste your integration keys into the appropriate service fields
3. Click "Send Alert" on any service
4. **Watch what happens**:
   - Incident appears in PagerDuty web UI
   - **Notification appears in MS Teams** (banner pop-up)
   - **Incident shows in PagerDuty app in Teams**
   - On-call person receives push notification
   - Escalation starts if not acknowledged

### Using Command Line (curl)

**Critical Power Alert:**
```bash
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "YOUR_POWER_INTEGRATION_KEY",
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

**HVAC Warning:**
```bash
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "YOUR_HVAC_INTEGRATION_KEY",
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

### What Happens Next?

1. **Alert arrives** in PagerDuty
2. **Severity mapped** to priority (critical→P1, warning→P3)
3. **Location extracted** and added to incident title: `[Sydney DC - Floor 3] UPS Battery Low`
4. **Escalation triggered** to appropriate team
5. **Notifications sent** via multiple channels:
   - 📱 **MS Teams notification** (banner pop-up)
   - 📧 Email
   - 📲 Push notification (mobile app)
   - 📞 SMS (if configured)
   - ☎️ Voice call (if escalated)
6. **MS Teams incident chat created** (if workflow configured)
7. **Incident appears in PagerDuty app in Teams**
8. **Structured update prompt** sent to responders
9. **Status page updated** (if configured)

### Managing Incidents in MS Teams

**Acknowledge an incident:**
1. Open the PagerDuty app in Teams
2. Go to **Incidents** tab
3. Click on the incident
4. Click **Acknowledge**
   - Or use command: `/pagerduty ack [incident-number]`

**Add a note:**
1. Open the incident in the PagerDuty app
2. Click **Add Note**
3. Type your update (e.g., "Checking UPS battery connections")
4. Click **Send**

**Resolve an incident:**
1. Open the incident
2. Click **Resolve**
3. Add a resolution note (optional but recommended)
   - Or use command: `/pagerduty resolve [incident-number]`

**Escalate to someone:**
1. Open the incident
2. Click **Reassign** or **Add Responders**
3. Select the person or escalation policy
4. Click **Assign**

**You can manage your entire incident lifecycle without leaving Teams!** 🚀

---

## 📊 What's Included: Complete Feature List

### ✅ Alert Processing & Routing
- **Event Orchestrations**: Automatic severity mapping (critical→P1, error→P2, warning→P3, info→P4)
- **Intelligent Grouping**: Related alerts consolidated into single incidents
- **Location Extraction**: Alerts show as `[Location] Summary` when location data present
- **Dynamic Routing**: Alerts routed to specialized teams based on service type

### ✅ Escalation & Notifications
- **Multi-Channel Alerting**: MS Teams, push, SMS, voice, email
- **Escalation Policies**: Configurable timeouts (1-10 minutes)
- **Dual Notification**: Critical systems notify via 2 channels simultaneously
- **24/7 Coverage**: 7 on-call schedules with primary/secondary/manager escalation

### ✅ Microsoft Teams Integration
- **Native App**: Full PagerDuty app in MS Teams
- **Incident Notifications**: Real-time alerts in Teams
- **Incident Management**: Ack, resolve, add notes from Teams
- **Slash Commands**: `/pagerduty` commands for quick actions
- **Status Sync**: Teams status updates when on-call or in incident
- **Incident Chats**: Auto-create dedicated Teams chats for incidents
- **Channel Integration**: Post incidents to specific team channels

### ✅ Automated Workflows
- **MS Teams Chat Creation**: Auto-create incident-specific chats
- **Conference Bridges**: Automatically added to critical incidents
- **Responder Assignment**: Auto-add specialists based on incident type
- **Structured Updates**: System-specific checklists (HVAC, Power, Network, Security)
- **CMMS Integration**: Workflow to create work orders (MSIM/Chekhub ready)

### ✅ AI-Powered Response (Requires AI Ops Add-On)
- **SRE Agent**: AI-driven diagnostic recommendations
- **Runbook Integration**: Automatic procedure suggestions
- **Context Analysis**: AI analyzes incident patterns and suggests actions

### ✅ Stakeholder Communications
- **Business Services**: Map technical services to business impact
- **Internal Status Pages**: Ops team visibility
- **External Status Pages**: Customer-facing communications
- **Approval Workflows**: Controlled external messaging
- **Customer Q&A Channel**: Dedicated MS Teams channel for customer questions

### ✅ Response Plays
- **Power Outage Response**: Automated mobilization for power failures
- **Fire Alarm Response**: Life safety critical procedures
- **Security Breach Response**: Security incident protocols

---

## 📁 Repository Structure Explained

```
.
├── README.md                          # This file
├── pagerduty-datacenter-demo.html     # Interactive demo interface
├── terraform.tfvars.example           # Configuration template
│
├── main.tf                            # Terraform provider setup
├── variables.tf                       # Configurable parameters
├── outputs.tf                         # Integration keys output
│
├── users.tf                           # 15 demo users
├── teams.tf                           # 4 response teams
├── schedules.tf                       # 7 on-call schedules
├── escalation_policies.tf             # 6 escalation policies
├── services.tf                        # 6 monitored services
├── services_integrations_addon.tf     # Integration configurations
├── priorities.tf                      # P1-P4 priority references
│
├── event_orchestrations.tf            # Alert processing rules
├── business_services.tf               # Business service mapping
├── service_dependencies.tf            # Service relationships
│
├── incident_workflows.tf              # Automated response workflows
├── workflows_structured_updates.tf    # System-specific update prompts
├── workflows_cmms.tf                  # CMMS integration workflow
│
└── runbooks/                          # Sample runbooks for SRE Agent
    ├── power_failure_response.md
    ├── hvac_failure_response.md
    └── fire_alarm_response.md
```

---

## 🎓 Learning Path: Explore PagerDuty Features

### Week 1: Core Incident Management + MS Teams
1. **Install PagerDuty app in MS Teams** (Step 6 above)
2. **Send test alerts** using the HTML demo
3. **Manage incidents from Teams**: Acknowledge, add notes, resolve
4. **Test escalations** by not acknowledging alerts
5. **Try different severities** (critical, error, warning, info)
6. **Use slash commands**: `/pagerduty oncall`, `/pagerduty trigger`
7. **Download mobile app** and test notifications

### Week 2: Workflows & Automation
1. **Trigger incident workflows** and observe automated actions
2. **Watch MS Teams incident chats** being created automatically
3. **Explore structured update prompts** for different service types
4. **Try the CMMS workflow** (manual trigger from incident)
5. **Review Business Services** to understand impact mapping
6. **Test status sync**: Go on-call and see your Teams status change

### Week 3: Advanced Features
1. **Set up Status Pages** (internal and external)
2. **Configure approval workflows** for external communications
3. **Test alert grouping** by sending multiple related alerts
4. **Explore AI Ops** (if available) with SRE Agent
5. **Upload custom runbooks** to SRE Agent
6. **Add PagerDuty to a team channel** for group visibility

### Week 4: Customization & Integration
1. **Modify escalation policies** to match your needs
2. **Adjust on-call schedules** for your timezone
3. **Create custom orchestration rules** for your alert formats
4. **Add your own services** and integrations
5. **Integrate with your real systems** (BMS, CMMS, etc.)
6. **Customize MS Teams notifications** per service

---

## 🔧 Customization Guide

### Change Timezone

Edit `schedules.tf` and replace `Australia/Sydney` with your timezone:
```hcl
time_zone = "America/New_York"  # or your timezone
```

### Adjust Escalation Timing

Edit `escalation_policies.tf`:
```hcl
escalation_delay_in_minutes = 5  # Change from default
```

### Add Your Own Service

Edit `services.tf`:
```hcl
resource "pagerduty_service" "my_service" {
  name                    = "My Custom Service"
  description            = "Description of my service"
  auto_resolve_timeout   = 14400
  acknowledgement_timeout = 600
  escalation_policy      = pagerduty_escalation_policy.critical_infrastructure.id
  alert_creation         = "create_alerts_and_incidents"
}
```

### Use Real Email Addresses

Edit `terraform.tfvars`:
```hcl
# Replace demo emails with real ones
user_emails = {
  alex_turner    = "alex@yourcompany.com"
  sarah_chen     = "sarah@yourcompany.com"
  # ... etc
}
```

### Customize MS Teams Notifications Per Service

In `incident_workflows.tf`, you can customize which services trigger Teams chats:

```hcl
# Only create Teams chats for P1 incidents
condition {
  expression = "incident.priority matches 'P1'"
}
```

---

## 🐛 Troubleshooting

### MS Teams Integration Issues

#### "Can't find PagerDuty app in Teams"
**Solution**: 
1. Check your organization's app policies (admin may need to approve)
2. Try searching in the Teams app store: https://teams.microsoft.com/l/app/989bc7c6-f5e4-4c3b-8b6e-3c4c3b8b6e3c
3. Contact your IT admin to enable third-party apps

#### "Sign in failed" or "Authorization error"
**Solution**:
1. Make sure you're signing in with the same account as your PagerDuty trial
2. Clear your browser cache and try again
3. Try signing in from an incognito/private browser window
4. Check that your PagerDuty trial account is active

#### "Not receiving notifications in Teams"
**Solution**:
1. Check notification settings in the PagerDuty app (Settings tab)
2. Verify Teams notifications are enabled in your OS
3. Check Teams notification settings: Settings → Notifications → ensure PagerDuty is allowed
4. Test with `/pagerduty trigger` command to create a test incident

#### "Slash commands not working"
**Solution**:
1. Make sure you type `/pagerduty` with the forward slash
2. Wait a moment after typing for autocomplete to appear
3. Reinstall the PagerDuty app if commands don't appear
4. Check that the app is properly connected (Settings tab should show "Connected")

### Terraform Issues

#### "License error: Unable to perform request"
**Problem**: Your trial account has a user limit (typically 5-10 users)

**Solution**: Edit `users.tf` and comment out extra users:
```hcl
# resource "pagerduty_user" "user_name" {
#   name  = "User Name"
#   email = "user@example.com"
#   role  = "user"
# }
```
Keep only the number of users your trial allows.

#### "User email already exists"
**Problem**: Email addresses must be unique in PagerDuty

**Solution**: Change emails in `terraform.tfvars` to unique addresses

#### "Invalid API token"
**Problem**: Token is incorrect, expired, or has insufficient permissions

**Solution**: 
1. Verify you copied the entire token (no spaces)
2. Create a new API token with full access
3. Update `terraform.tfvars` with the new token

#### "Priority not found"
**Problem**: P1-P4 priorities don't exist in your account

**Solution**: 
1. Go to PagerDuty → **Incident Priorities**
2. Create priorities: P1 (Critical), P2 (High), P3 (Medium), P4 (Low)
3. Or comment out priority references in `event_orchestrations.tf`

#### Terraform Command Not Found
**Problem**: Terraform not installed or not in PATH

**Solution**: Follow Step 1 installation instructions above

#### Changes Not Applying
**Problem**: Terraform state out of sync

**Solution**:
```bash
terraform refresh
terraform plan
terraform apply
```

---

## 🧹 Cleanup / Removal

When you're done evaluating, remove all demo resources:

```bash
terraform destroy
```

Type `yes` when prompted.

**This will delete**:
- All 15 demo users
- All 4 teams
- All 6 services and integrations
- All schedules and escalation policies
- All workflows and orchestrations
- All business services

**This will NOT delete**:
- Your PagerDuty account
- Any manually created resources
- Incident history
- Your MS Teams app installation (uninstall separately if desired)

**To uninstall PagerDuty from MS Teams**:
1. Right-click the PagerDuty app in Teams sidebar
2. Select **Uninstall**
3. Confirm removal

---

## 📚 Additional Resources

### PagerDuty Documentation
- [Getting Started Guide](https://support.pagerduty.com/docs/quick-start-guide)
- [Events API v2](https://developer.pagerduty.com/docs/ZG9jOjExMDI5NTgw-events-api-v2-overview)
- [Event Orchestrations](https://support.pagerduty.com/docs/event-orchestration)
- [Incident Workflows](https://support.pagerduty.com/docs/incident-workflows)
- [Status Pages](https://support.pagerduty.com/docs/status-pages)
- [Microsoft Teams Integration](https://support.pagerduty.com/docs/microsoft-teams)

### Terraform Resources
- [PagerDuty Terraform Provider](https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs)
- [Terraform Basics](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)

### Integration Guides
- [Niagara BMS Integration](https://support.pagerduty.com/docs/niagara-integration-guide)
- [Microsoft Teams Integration](https://support.pagerduty.com/docs/microsoft-teams)
- [Slack Integration](https://support.pagerduty.com/docs/slack-integration-guide)

---

## 💡 Tips for Your Evaluation

### Focus Areas

**Week 1**: Core incident management + MS Teams
- Can PagerDuty reliably receive and route your alerts?
- Do escalation policies match your team structure?
- Is the MS Teams integration seamless?
- Is the mobile app experience acceptable?

**Week 2**: Automation & workflows
- Do automated workflows reduce manual work?
- Are structured updates helpful for your processes?
- Does MS Teams integration improve collaboration?
- Can you manage incidents without leaving Teams?

**Week 3**: Advanced features
- Do status pages meet stakeholder communication needs?
- Does alert grouping reduce noise?
- Is AI Ops valuable for your use cases?
- Does the Teams status sync help with visibility?

**Week 4**: Integration & customization
- Can you integrate with your existing tools (BMS, CMMS)?
- Is the platform flexible enough for your needs?
- What's the implementation effort?
- Does it fit your team's workflow?

### Questions to Answer

- [ ] Does PagerDuty reduce mean time to acknowledge (MTTA)?
- [ ] Does it reduce mean time to resolve (MTTR)?
- [ ] Does it improve stakeholder communication?
- [ ] Does it reduce manual work and human error?
- [ ] Can it scale with your growth?
- [ ] Is the MS Teams integration valuable for your team?
- [ ] Can responders work effectively from Teams alone?
- [ ] Is the ROI justifiable?

### MS Teams-Specific Evaluation

- [ ] Can responders acknowledge incidents from Teams notifications?
- [ ] Are slash commands intuitive and useful?
- [ ] Does status sync provide value (showing on-call status)?
- [ ] Do incident chats improve collaboration?
- [ ] Is channel integration useful for team visibility?
- [ ] Can managers get visibility without PagerDuty login?

---

## 🤝 Support & Feedback

### Getting Help

1. **PagerDuty Support**: Available in your trial account (Help icon)
2. **Community Forum**: [community.pagerduty.com](https://community.pagerduty.com)
3. **Documentation**: [support.pagerduty.com](https://support.pagerduty.com)
4. **MS Teams Integration Help**: [support.pagerduty.com/docs/microsoft-teams](https://support.pagerduty.com/docs/microsoft-teams)

### Providing Feedback on This Demo

If you have suggestions for improving this demo repository:
- Open an issue on GitHub
- Submit a pull request
- Contact your PagerDuty sales representative

---

## 📧 About This Demo

**Version**: 3.1  
**Last Updated**: March 2026  
**Maintained By**: PagerDuty Solutions Engineering  
**License**: MIT  
**Timezone**: Australia/Sydney (UTC+11) - easily customizable  
**Primary Interface**: Microsoft Teams + PagerDuty Web/Mobile

**Use Case**: Datacenter / Critical Infrastructure Operations  
**Industry**: Data Centers, Facilities Management, Critical Infrastructure  
**Complexity**: Intermediate (suitable for evaluation)  

---

## ✅ Quick Start Checklist

- [ ] Terraform installed and verified
- [ ] PagerDuty trial account created
- [ ] API token generated and saved
- [ ] Repository downloaded
- [ ] `terraform.tfvars` configured
- [ ] `terraform init` completed
- [ ] `terraform apply` successful
- [ ] **PagerDuty app installed in MS Teams**
- [ ] **PagerDuty app connected to trial account**
- [ ] **Notification preferences configured in Teams**
- [ ] **Tested `/pagerduty oncall` command**
- [ ] Integration keys saved
- [ ] First test alert sent
- [ ] **Incident notification received in Teams**
- [ ] **Incident acknowledged from Teams**
- [ ] Mobile app tested
- [ ] Workflows explored

**Ready to evaluate PagerDuty? Start with Step 1 above!** 🚀
