# PagerDuty Provider Variables
variable "pagerduty_token" {
  description = "PagerDuty API token with full access"
  type        = string
  sensitive   = true
}

# Timezone Configuration
variable "timezone" {
  description = "Timezone for schedules (IANA format)"
  type        = string
  default     = "Australia/Sydney"
}

# MS Teams Configuration
variable "teams_webhook_power" {
  description = "MS Teams webhook URL for Power & Electrical channel"
  type        = string
  default     = "https://outlook.office.com/webhook/YOUR_WEBHOOK_POWER"
}

variable "teams_webhook_hvac" {
  description = "MS Teams webhook URL for HVAC & Cooling channel"
  type        = string
  default     = "https://outlook.office.com/webhook/YOUR_WEBHOOK_HVAC"
}

variable "teams_webhook_environmental" {
  description = "MS Teams webhook URL for Environmental Monitoring channel"
  type        = string
  default     = "https://outlook.office.com/webhook/YOUR_WEBHOOK_ENVIRONMENTAL"
}

variable "teams_webhook_security" {
  description = "MS Teams webhook URL for Physical Security channel"
  type        = string
  default     = "https://outlook.office.com/webhook/YOUR_WEBHOOK_SECURITY"
}

variable "teams_webhook_fire" {
  description = "MS Teams webhook URL for Fire & Life Safety channel"
  type        = string
  default     = "https://outlook.office.com/webhook/YOUR_WEBHOOK_FIRE"
}

variable "teams_webhook_network" {
  description = "MS Teams webhook URL for Network Infrastructure channel"
  type        = string
  default     = "https://outlook.office.com/webhook/YOUR_WEBHOOK_NETWORK"
}

# Conference Bridge Configuration
variable "conference_bridge_url" {
  description = "MS Teams conference bridge URL for incidents"
  type        = string
  default     = "https://teams.microsoft.com/l/meetup-join/sydney-datacenter-ops"
}
