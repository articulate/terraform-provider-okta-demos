data okta_group everyone {
  name = "Everyone"
}

resource okta_group staff {
  name = "Staff"
}

resource okta_group_roles roles {
  group_id    = "${okta_group.staff.id}"
  admin_roles = ["SUPER_ADMIN"]
}

resource okta_group_rule staff {
  // Do not create if group rule feature is not available
  count             = "${var.enable_group_rule ? 1 : 0}"
  name              = "Staff group rule"
  status            = "ACTIVE"
  group_assignments = ["${okta_group.staff.id}"]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "String.substringAfter(user.login, \"@\") == \"${var.domain}\""
}

resource okta_group people {
  name        = "People"
  description = "People being people and stuff"
}
