resource okta_user user {
  email             = "${var.email}"
  login             = "${var.login == "" ? var.email : var.login}"
  first_name        = "${var.first_name}"
  last_name         = "${var.last_name}"
  group_memberships = "${var.groups}"
  mobile_phone      = "${var.mobile_phone}"
  admin_roles       = "${var.admin_roles}"
  division          = "${var.division}"
  organization      = "${var.organization}"
  manager           = "${var.manager}"
  title             = "${var.title}"

  custom_profile_attributes = <<JSON
{
  "bio": "${var.bio}"
}
JSON

  // Ignore changes via the Okta dashboard
  lifecycle {
    ignore_changes = ["first_name", "last_name", "mobile_phone", "title"]
  }
}
