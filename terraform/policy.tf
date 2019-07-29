resource okta_policy_signon staff_signon {
  name            = "Staff Sign On Policy"
  status          = "ACTIVE"
  priority        = 1
  groups_included = ["${okta_group.staff.id}"]
}

resource okta_policy_rule_signon staff_signon {
  policyid            = "${okta_policy_signon.staff_signon.id}"
  name                = "Staff Sign On Rule"
  priority            = 1
  status              = "ACTIVE"
  access              = "ALLOW"
  authtype            = "ANY"
  enroll              = "CHALLENGE"
  mfa_prompt          = "ALWAYS"
  mfa_remember_device = false
  mfa_required        = true
  session_idle        = 43200
  session_lifetime    = 43200
  session_persistent  = true
}

resource okta_policy_password staff_pwd {
  name                          = "Staff Password Policy"
  groups_included               = ["${okta_group.staff.id}"]
  priority                      = 1
  password_min_length           = 16
  password_min_lowercase        = 1
  password_min_uppercase        = 1
  password_min_number           = 1
  password_min_symbol           = 1
  password_exclude_username     = true
  password_max_lockout_attempts = 5
  password_history_count        = 4
  email_recovery                = "ACTIVE"
  recovery_email_token          = 10080
}

resource okta_policy_rule_password staff_pwd {
  policyid = "${okta_policy_password.staff_pwd.id}"
  priority = 1
  name     = "Staff Password Policy Rule"
  status   = "ACTIVE"
}

resource okta_policy_signon signon {
  name            = "Sign On Policy"
  status          = "ACTIVE"
  priority        = 2
  groups_included = ["${data.okta_group.everyone.id}"]
}

resource okta_policy_rule_signon signon {
  policyid            = "${okta_policy_signon.signon.id}"
  name                = "Sign On Rule"
  priority            = 1
  status              = "ACTIVE"
  access              = "ALLOW"
  authtype            = "ANY"
  enroll              = "CHALLENGE"
  mfa_remember_device = false
  mfa_required        = false
  session_idle        = 43200
  session_lifetime    = 43200
  session_persistent  = true
}

resource okta_policy_password pwd {
  name                          = "Password Policy"
  groups_included               = ["${data.okta_group.everyone.id}"]
  priority                      = 2
  password_min_length           = 16
  password_min_lowercase        = 1
  password_min_uppercase        = 1
  password_min_number           = 1
  password_min_symbol           = 1
  password_exclude_username     = true
  password_max_lockout_attempts = 5
  password_history_count        = 4
  email_recovery                = "ACTIVE"
  recovery_email_token          = 10080
}

resource okta_policy_rule_password pwd {
  policyid = "${okta_policy_password.pwd.id}"
  priority = 1
  name     = "Password Policy Rule"
  status   = "ACTIVE"
}

resource okta_factor google_otp {
  provider_id = "google_otp"
}

resource okta_factor okta_otp {
  provider_id = "okta_otp"
}
