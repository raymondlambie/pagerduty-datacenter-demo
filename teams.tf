# Datacenter Operations Team
resource "pagerduty_team" "datacenter_ops" {
  name        = "Datacenter Operations"
  description = "Primary datacenter infrastructure and operations team"
}

resource "pagerduty_team_membership" "ops_alex" {
  team_id = pagerduty_team.datacenter_ops.id
  user_id = pagerduty_user.alex_turner.id
  role    = "manager"
}

resource "pagerduty_team_membership" "ops_sarah" {
  team_id = pagerduty_team.datacenter_ops.id
  user_id = pagerduty_user.sarah_chen.id
  role    = "responder"
}

resource "pagerduty_team_membership" "ops_mike" {
  team_id = pagerduty_team.datacenter_ops.id
  user_id = pagerduty_user.mike_rodriguez.id
  role    = "responder"
}

# Environmental Systems Team
resource "pagerduty_team" "environmental" {
  name        = "Environmental Systems"
  description = "HVAC, cooling, and environmental monitoring specialists"
}

resource "pagerduty_team_membership" "env_emma" {
  team_id = pagerduty_team.environmental.id
  user_id = pagerduty_user.emma_wilson.id
  role    = "manager"
}

resource "pagerduty_team_membership" "env_david" {
  team_id = pagerduty_team.environmental.id
  user_id = pagerduty_user.david_kim.id
  role    = "responder"
}

resource "pagerduty_team_membership" "env_lisa" {
  team_id = pagerduty_team.environmental.id
  user_id = pagerduty_user.lisa_patel.id
  role    = "responder"
}

# Security Team
resource "pagerduty_team" "security" {
  name        = "Physical Security"
  description = "Physical security and access control team"
}

resource "pagerduty_team_membership" "sec_james" {
  team_id = pagerduty_team.security.id
  user_id = pagerduty_user.james_murphy.id
  role    = "manager"
}

resource "pagerduty_team_membership" "sec_rachel" {
  team_id = pagerduty_team.security.id
  user_id = pagerduty_user.rachel_foster.id
  role    = "responder"
}

resource "pagerduty_team_membership" "sec_kevin" {
  team_id = pagerduty_team.security.id
  user_id = pagerduty_user.kevin_zhang.id
  role    = "responder"
}

# Management Team
resource "pagerduty_team" "management" {
  name        = "Datacenter Management"
  description = "Executive and management escalation team"
}

resource "pagerduty_team_membership" "mgmt_jennifer" {
  team_id = pagerduty_team.management.id
  user_id = pagerduty_user.jennifer_brooks.id
  role    = "manager"
}

resource "pagerduty_team_membership" "mgmt_robert" {
  team_id = pagerduty_team.management.id
  user_id = pagerduty_user.robert_taylor.id
  role    = "manager"
}

resource "pagerduty_team_membership" "mgmt_amanda" {
  team_id = pagerduty_team.management.id
  user_id = pagerduty_user.amanda_lee.id
  role    = "responder"
}
