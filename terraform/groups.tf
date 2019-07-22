data okta_group everyone {
  name = "Everyone"
}

resource okta_group staff {
  name = "Staff"
}

resource okta_group_rule staff {
  name              = "Staff group rule"
  status            = "ACTIVE"
  group_assignments = ["${okta_group.staff.id}"]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "String.substringAfter(user.login, \"@\") == \"example.com\""
}

resource okta_group_roles roles {
  group_id    = "${okta_group.staff.id}"
  admin_roles = ["SUPER_ADMIN"]
}
