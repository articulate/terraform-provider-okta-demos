data okta_auth_server default {
  name = "default"
}

resource okta_auth_server_claim first_name {
  auth_server_id = "${data.okta_auth_server.default.id}"
  name           = "first_name"
  value          = "user.firstName"
  scopes         = ["profile_name"]
  claim_type     = "IDENTITY"
}

resource okta_auth_server_claim last_name {
  auth_server_id = "${data.okta_auth_server.default.id}"
  name           = "last_name"
  value          = "user.lastName"
  scopes         = ["profile_name"]
  claim_type     = "IDENTITY"
}

resource okta_auth_server_scope profile_name {
  auth_server_id   = "${data.okta_auth_server.default.id}"
  metadata_publish = "NO_CLIENTS"
  name             = "profile_name"
  consent          = "IMPLICIT"
}

resource okta_auth_server_scope staff {
  auth_server_id   = "${data.okta_auth_server.default.id}"
  metadata_publish = "NO_CLIENTS"
  name             = "staff"
  consent          = "IMPLICIT"
}

resource okta_auth_server_claim staff {
  auth_server_id = "${data.okta_auth_server.default.id}"
  name           = "staff"
  value          = "String.substringAfter(user.email, \"@\") == \"${var.domain}\""
  scopes         = ["${okta_auth_server_scope.staff.name}"]
  claim_type     = "IDENTITY"
}
