resource okta_idp_saml_key idp {
  x5c = ["${base64encode(var.signing_certificate)}"]
}

resource okta_idp_saml idp {
  name                     = "Customer X IdP"
  acs_binding              = "HTTP-POST"
  acs_type                 = "ORG"
  sso_url                  = "${var.sso_url}"
  sso_destination          = "${var.sso_url}"
  sso_binding              = "HTTP-POST"
  username_template        = "idpuser.email"
  kid                      = "${okta_idp_saml_key.idp.id}"
  issuer                   = "${var.issuer}"
  request_signature_scope  = "REQUEST"
  response_signature_scope = "ANY"
  profile_master           = false
}

resource okta_idp_social google {
  type          = "GOOGLE"
  protocol_type = "OAUTH2"
  name          = "Google Auth"

  scopes = [
    "profile",
    "email",
    "openid",
  ]

  client_id         = "placeholder"
  client_secret     = "placeholder"
  username_template = "idpuser.email"
}
