terraform {
  required_version = ">= 1.0"

  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "~> 3.0"
    }
  }
}

provider "pagerduty" {
  token = var.pagerduty_token
}
