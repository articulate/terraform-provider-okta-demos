data okta_policy idp_policy {
  name = "Idp Discovery Policy"
  type = "IDP_DISCOVERY"
}

resource okta_policy_rule_idp_discovery discovery {
  policyid             = "${data.okta_policy.idp_policy.id}"
  priority             = 1
  name                 = "Customer"
  idp_type             = "SAML2"
  idp_id               = "${okta_idp_saml.idp.id}"
  user_identifier_type = "IDENTIFIER"

  user_identifier_patterns {
    match_type = "SUFFIX"
    value      = "${var.domain}"
  }
}
