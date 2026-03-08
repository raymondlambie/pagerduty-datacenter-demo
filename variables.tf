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
