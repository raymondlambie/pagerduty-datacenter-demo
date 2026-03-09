variable "pagerduty_token" {
  description = "PagerDuty API Token"
  type        = string
  sensitive   = true
}

variable "datacenter_timezone" {
  description = "Timezone for datacenter schedules"
  type        = string
  default     = "Australia/Sydney"
}

variable "timezone" {
  description = "Timezone for schedules"
  type        = string
  default     = "Australia/Sydney"
}

variable "teams_channel_incidents" {
  description = "MS Teams channel for incident notifications"
  type        = string
  default     = "https://teams.microsoft.com/l/channel/incidents"
}

variable "conference_bridge_url" {
  description = "MS Teams conference bridge URL for incident response"
  type        = string
  default     = "https://teams.microsoft.com/l/meetup-join/datacenter-ops"
}

variable "admin_email" {
  description = "Admin email address"
  type        = string
}

# ============================================================================
# CMMS Integration
# ============================================================================

variable "cmms_webhook_url" {
  description = "Webhook URL for CMMS work order creation (use webhook.site for demo)"
  type        = string
  default     = "https://webhook.site/your-unique-url"
}

# MS Teams Integration Variables
variable "msteams_org_id" {
  description = "Microsoft Teams Organization ID for chat creation"
  type        = string
  default     = "dd649b90-2b30-45cb-a264-1130134c625e"
}

variable "msteams_user_id" {
  description = "PagerDuty User ID for MS Teams integration"
  type        = string
  default     = "PY4G4Q1"
}
