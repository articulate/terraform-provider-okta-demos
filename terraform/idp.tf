resource okta_idp_saml_key idp {
  x5c = ["${base64encode(data.local_file.cert.content)}"]
}

resource okta_idp_saml idp {
  name                     = "Articulate"
  acs_binding              = "HTTP-POST"
  acs_type                 = "ORG"
  sso_url                  = "${local.sso_url}"
  sso_destination          = "${local.sso_url}"
  sso_binding              = "HTTP-POST"
  username_template        = "idpuser.email"
  kid                      = "${okta_idp_saml_key.idp.id}"
  issuer                   = "${local.issuer}"
  request_signature_scope  = "REQUEST"
  response_signature_scope = "ANY"
  profile_master           = false
}
