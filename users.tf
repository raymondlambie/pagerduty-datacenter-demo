# Datacenter Operations Team Users
resource "pagerduty_user" "alex_turner" {
  name  = "Alex Turner"
  email = "alex.turner@raygen.net"
  role  = "user"
}

resource "pagerduty_user" "sarah_chen" {
  name  = "Sarah Chen"
  email = "sarah.chen@raygen.net"
  role  = "user"
}

resource "pagerduty_user" "mike_rodriguez" {
  name  = "Mike Rodriguez"
  email = "mike.rodriguez@raygen.net"
  role  = "user"
}

# Environmental Systems Team Users
resource "pagerduty_user" "emma_wilson" {
  name  = "Emma Wilson"
  email = "emma.wilson@raygen.net"
  role  = "user"
}

resource "pagerduty_user" "david_kim" {
  name  = "David Kim"
  email = "david.kim@raygen.net"
  role  = "user"
}

resource "pagerduty_user" "lisa_patel" {
  name  = "Lisa Patel"
  email = "lisa.patel@raygen.net"
  role  = "user"
}

# Security Team Users
resource "pagerduty_user" "james_murphy" {
  name  = "James Murphy"
  email = "james.murphy@raygen.net"
  role  = "user"
}

resource "pagerduty_user" "rachel_foster" {
  name  = "Rachel Foster"
  email = "rachel.foster@raygen.net"
  role  = "user"
}

resource "pagerduty_user" "kevin_zhang" {
  name  = "Kevin Zhang"
  email = "kevin.zhang@raygen.net"
  role  = "user"
}

# Management Team Users
resource "pagerduty_user" "jennifer_brooks" {
  name  = "Jennifer Brooks"
  email = "jennifer.brooks@raygen.net"
  role  = "admin"
}

resource "pagerduty_user" "robert_taylor" {
  name  = "Robert Taylor"
  email = "robert.taylor@raygen.net"
  role  = "admin"
}

resource "pagerduty_user" "amanda_lee" {
  name  = "Amanda Lee"
  email = "amanda.lee@raygen.net"
  role  = "user"
}
