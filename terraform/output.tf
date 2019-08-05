data okta_idp_metadata_saml idp {
  idp_id = "${okta_idp_saml.idp.id}"
}

output audience {
  value = "${okta_idp_saml.idp.audience}"
}

output certificate {
  value = "${data.okta_idp_metadata_saml.idp.signing_certificate}"
}

output sso_url {
  value = "${data.okta_idp_metadata_saml.idp.http_post_binding}"
}

resource local_file app_credentials {
  content = <<EOF
CLIENT_ID=${okta_app_oauth.my_app.client_id}
CLIENT_SECRET=${okta_app_oauth.my_app.client_secret}
EOF

  filename = "${path.module}/.env"
}
