# PagerDuty Datacenter Demo - MS Teams Integration

## MS Teams Channel Setup

### Step 1: Create MS Teams Channels

Create the following channels in your MS Teams workspace:

1. **Power & Electrical Alerts**
2. **HVAC & Cooling Alerts**
3. **Environmental Monitoring Alerts**
4. **Physical Security Alerts**
5. **Fire & Life Safety Alerts**
6. **Network Infrastructure Alerts**

### Step 2: Create Incoming Webhooks for Each Channel

For each channel created above:

1. Click the **...** (three dots) next to the channel name
2. Select **Connectors**
3. Search for **Incoming Webhook**
4. Click **Configure**
5. Give it a name (e.g., "PagerDuty Alerts")
6. Optionally upload a PagerDuty logo
7. Click **Create**
8. **Copy the webhook URL** - you'll need this for terraform.tfvars

### Step 3: Update terraform.tfvars

Add the webhook URLs to your `terraform.tfvars` file:

```hcl
# MS Teams Webhook URLs
teams_webhook_power         = "https://outlook.office.com/webhook/xxxxx/IncomingWebhook/xxxxx"
teams_webhook_hvac          = "https://outlook.office.com/webhook/xxxxx/IncomingWebhook/xxxxx"
teams_webhook_environmental = "https://outlook.office.com/webhook/xxxxx/IncomingWebhook/xxxxx"
teams_webhook_security      = "https://outlook.office.com/webhook/xxxxx/IncomingWebhook/xxxxx"
teams_webhook_fire          = "https://outlook.office.com/webhook/xxxxx/IncomingWebhook/xxxxx"
teams_webhook_network       = "https://outlook.office.com/webhook/xxxxx/IncomingWebhook/xxxxx"
```

### Step 4: Create MS Teams Meeting Link (Conference Bridge)

1. In MS Teams, schedule a recurring meeting called "Datacenter Ops - Incident Response"
2. Set it to recur indefinitely
3. Copy the **Join Microsoft Teams Meeting** link
4. Add it to `terraform.tfvars`:

```hcl
conference_bridge_url = "https://teams.microsoft.com/l/meetup-join/xxxxx"
```

## What This Configuration Does

### MS Teams Extensions
- Each PagerDuty service has a dedicated MS Teams extension
- When an incident is triggered, a message is posted to the corresponding MS Teams channel
- Messages include incident details, severity, and action buttons

### Notification Flow
1. **BMS Alert** → Niagara sends alert to PagerDuty
2. **PagerDuty Incident** → Creates incident and notifies on-call responders
3. **MS Teams Notification** → Posts to dedicated channel
4. **CMMS Work Order** → Auto-creates work order in MCIM or CheckHub
5. **Conference Bridge** → Responders join MS Teams meeting for collaboration

## Testing MS Teams Integration

After running `terraform apply`, test each channel:

1. Use the demo harness HTML file to send test alerts
2. Verify messages appear in the correct MS Teams channels
3. Check that incident details are properly formatted
4. Confirm action buttons work (Acknowledge, Resolve)

## Troubleshooting

### Webhook Not Working
- Verify the webhook URL is correct and hasn't expired
- Check that the connector is still enabled in MS Teams
- Ensure the channel hasn't been deleted or renamed

### Messages Not Appearing
- Check PagerDuty service configuration
- Verify the extension is properly linked to the service
- Review PagerDuty activity logs for errors

### Conference Bridge Issues
- Ensure the meeting link is a recurring meeting
- Verify the link hasn't expired
- Check that external participants are allowed (if needed)

## Key Differences from Slack

| Feature | Slack | MS Teams |
|---------|-------|----------|
| Extension Type | Slack V2 | Microsoft Teams |
| Webhook Format | `https://hooks.slack.com/services/...` | `https://outlook.office.com/webhook/...` |
| Channel Reference | `#channel-name` | Direct webhook per channel |
| Setup Location | Slack App Directory | MS Teams Connectors |
| Message Format | Slack Blocks | Adaptive Cards |

## Next Steps

1. ✅ Create MS Teams channels
2. ✅ Configure incoming webhooks
3. ✅ Update terraform.tfvars with webhook URLs
4. ✅ Create recurring meeting for conference bridge
5. ✅ Run `terraform plan` to verify configuration
6. ✅ Run `terraform apply` to create resources
7. ✅ Test each service with demo alerts
8. ✅ Verify CMMS integration (MCIM/CheckHub)
