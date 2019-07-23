resource okta_app_oauth my_app {
  label = "My App"
  type  = "web"

  grant_types = [
    "authorization_code",
    "refresh_token",
    "implicit",
  ]

  response_types = [
    "id_token",
    "code",
  ]

  redirect_uris             = ["https://${var.domain}/auth-callback"]
  post_logout_redirect_uris = ["https://${var.domain}"]
  login_uri                 = "https://${var.domain}"
  groups                    = ["${data.okta_group.everyone.id}"]
}
