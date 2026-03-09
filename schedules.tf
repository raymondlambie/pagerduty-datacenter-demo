# Primary On-Call Schedule (24/7 rotation)
resource "pagerduty_schedule" "primary_oncall" {
  name      = "Primary On-Call"
  time_zone = var.datacenter_timezone

  teams = [
    pagerduty_team.datacenter_ops.id,
    pagerduty_team.security.id,
    pagerduty_team.environmental.id
  ]

  layer {
    name                         = "Primary 24/7 Rotation"
    start                        = "2026-03-01T09:00:00+11:00"
    rotation_virtual_start       = "2026-03-01T09:00:00+11:00"
    rotation_turn_length_seconds = 604800 # 1 week
    users = [
      pagerduty_user.sarah_chen.id,
      pagerduty_user.alex_turner.id,
      pagerduty_user.mike_rodriguez.id
    ]
  }
}

# Business Hours Support Schedule (Mon-Fri 9am-5pm)
resource "pagerduty_schedule" "business_hours" {
  name      = "Business Hours Support"
  time_zone = var.datacenter_timezone

  teams = [
    pagerduty_team.datacenter_ops.id
  ]

  layer {
    name                         = "Business Hours Coverage"
    start                        = "2026-03-03T09:00:00+11:00" # Monday
    rotation_virtual_start       = "2026-03-03T09:00:00+11:00"
    rotation_turn_length_seconds = 86400 # 1 day
    users = [
      pagerduty_user.sarah_chen.id,
      pagerduty_user.alex_turner.id
    ]

    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800 # 8 hours
      start_day_of_week = 1     # Monday
    }

    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800
      start_day_of_week = 2 # Tuesday
    }

    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800
      start_day_of_week = 3 # Wednesday
    }

    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800
      start_day_of_week = 4 # Thursday
    }

    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800
      start_day_of_week = 5 # Friday
    }
  }
}

# Environmental On-Call Schedule
resource "pagerduty_schedule" "environmental_oncall" {
  name      = "Environmental On-Call"
  time_zone = var.datacenter_timezone

  teams = [
    pagerduty_team.datacenter_ops.id,
    pagerduty_team.environmental.id
  ]

  layer {
    name                         = "Environmental Team Rotation"
    start                        = "2026-03-01T09:00:00+11:00"
    rotation_virtual_start       = "2026-03-01T09:00:00+11:00"
    rotation_turn_length_seconds = 604800 # 1 week
    users = [
      pagerduty_user.emma_wilson.id,
      pagerduty_user.david_kim.id,
      pagerduty_user.lisa_patel.id
    ]
  }
}

# Security On-Call Schedule
resource "pagerduty_schedule" "security_oncall" {
  name      = "Security On-Call"
  time_zone = var.datacenter_timezone

  teams = [
    pagerduty_team.datacenter_ops.id,
    pagerduty_team.security.id
  ]

  layer {
    name                         = "Security Team Rotation"
    start                        = "2026-03-01T09:00:00+11:00"
    rotation_virtual_start       = "2026-03-01T09:00:00+11:00"
    rotation_turn_length_seconds = 604800 # 1 week
    users = [
      pagerduty_user.james_murphy.id,
      pagerduty_user.rachel_foster.id,
      pagerduty_user.kevin_zhang.id
    ]
  }
}

# After Hours On-Call Schedule (Weeknights 5pm-9am + Weekends)
resource "pagerduty_schedule" "after_hours" {
  name      = "After Hours On-Call"
  time_zone = var.datacenter_timezone

  teams = [
    pagerduty_team.datacenter_ops.id
  ]

  layer {
    name                         = "After Hours Coverage"
    start                        = "2026-03-01T17:00:00+11:00"
    rotation_virtual_start       = "2026-03-01T17:00:00+11:00"
    rotation_turn_length_seconds = 604800 # 1 week
    users = [
      pagerduty_user.mike_rodriguez.id,
      pagerduty_user.david_kim.id,
      pagerduty_user.kevin_zhang.id
    ]

    # Weeknight coverage (5pm-9am)
    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "17:00:00"
      duration_seconds  = 57600 # 16 hours
      start_day_of_week = 1     # Monday evening
    }

    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "17:00:00"
      duration_seconds  = 57600
      start_day_of_week = 2 # Tuesday evening
    }

    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "17:00:00"
      duration_seconds  = 57600
      start_day_of_week = 3 # Wednesday evening
    }

    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "17:00:00"
      duration_seconds  = 57600
      start_day_of_week = 4 # Thursday evening
    }

    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "17:00:00"
      duration_seconds  = 57600
      start_day_of_week = 5 # Friday evening
    }

    # Weekend coverage (all day Saturday and Sunday)
    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "00:00:00"
      duration_seconds  = 86400 # 24 hours
      start_day_of_week = 6     # Saturday
    }

    restriction {
      type              = "weekly_restriction"
      start_time_of_day = "00:00:00"
      duration_seconds  = 86400
      start_day_of_week = 7 # Sunday
    }
  }
}

# Management Escalation Schedule
resource "pagerduty_schedule" "management_escalation" {
  name      = "Management Escalation"
  time_zone = var.datacenter_timezone

  teams = [
    pagerduty_team.datacenter_ops.id,
    pagerduty_team.security.id,
    pagerduty_team.environmental.id
  ]

  layer {
    name                         = "Management Team"
    start                        = "2026-03-01T09:00:00+11:00"
    rotation_virtual_start       = "2026-03-01T09:00:00+11:00"
    rotation_turn_length_seconds = 604800 # 1 week
    users = [
      pagerduty_user.sarah_chen.id,
      pagerduty_user.james_murphy.id
    ]
  }
}

# Power Specialists Schedule
resource "pagerduty_schedule" "power_specialists" {
  name      = "Power Specialists On-Call"
  time_zone = var.datacenter_timezone

  teams = [
    pagerduty_team.datacenter_ops.id
  ]

  layer {
    name                         = "Power Team Rotation"
    start                        = "2026-03-01T00:00:00+11:00"
    rotation_virtual_start       = "2026-03-01T00:00:00+11:00"
    rotation_turn_length_seconds = 604800 # 1 week
    users = [
      pagerduty_user.alex_turner.id,
      pagerduty_user.mike_rodriguez.id
    ]
  }
}
