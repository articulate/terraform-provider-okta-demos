# Terraform Provider Okta Demos

The purpose of this repository was to create a curriculum for a conference talk I did. It, serendipitously, is a great way to introduce yourself to using Terraform to build out Okta infrastructure.

## Prerequisites

Follow these steps in order to setup your environment to run this demo.

* [Install Docker](https://docs.docker.com/)
* [Install Docker Compose](https://docs.docker.com/compose/install/)
* [Create an Okta account](https://developer.okta.com/)
* [Create an API token](https://developer.okta.com/docs/guides/create-an-api-token/overview/)
* Clone this repository `git clone git@github.com:articulate/terraform-provider-okta-demos.git`
* Create env file `cp -n .env{.example,}`
* Set environment variables in `.env`

## What is Terraform

[Terraform](https://www.terraform.io/intro/index.html#what-is-terraform-) is a tool for building, changing, and versioning infrastructure safely and efficiently. For those familiar with DevOps tools and terminology, it supports configuration management, configuration orchestration, and provisioning. Configuration management tools allow you to install and manage software on existing systems. Some popular iterations of this type of tooling includes Chef, Puppet, Ansible, and of course Terraform. Configuration orchestration tools allow you to provision the servers themselves. Some well reputed implementations of this type of tooling includes CloudFormation and of course Terraform.

## Why Terraform

* *It supports reusable modules!* With Terraform you can create modules. Modules are essentially an abstracted set of resources that can be referenced multiple times with different inputs. The source can be remote or local. In fact, the top level configuration itself acts as a sort of module. You can provide it variables and run it in multiple contexts. For instance, if you have a stage and production environment, you can reuse the same configuration.

* *It really is code!* It utilizes Hashicorp Configuration Language or HCL syntax. With this comes some great features. It comes with built-in functions, you can even use terraform console command to experiment with them. It supports some advanced expressions including for loops, interpolation, directives, and much more.

* *Version control and validation.* You can store your configuration in version control. This means you can require code review before merging to master, you have a complete history of your infrastructure, you have the power to easily revert changes, and you can validate your infrastructure using static code analysis and/or integration tests.

* *It is safe and predictable!* Terraform provides you the ability to plan before you apply. You can run terraform plan. This pulls down your remote state, refreshes it against your actual downstream resources, compares it to your configuration, and outputs information about how your resources will change.

* *Terraform’s lifecycle is powerful!* A well written provider will refresh your state on every plan. This will detect and output configuration drift. For instance, if a colleague bypasses the Terraform config and manually makes a change in the UI. You will see it and be able to choose to represent it in the config or simply override it. Terraform also provides you with some great commands you can choose to import existing resources, remove resources from state without deleting the actual resource, taint a resource so it is recreated on the next run, and destroy a resource.

* *Use it for everything!* There are community as well as official providers for so many commonly used DevOps services.

## Setting Expectations

Anything exposed by Okta's APIs _can_ be configured with Okta. There are two caveats here, currently there is only a single major contributor. It is often very difficult to keep up with the demand. We will always accept pull requests! [Secondly, there are many operations that are not publicly exposed by Okta](#operations-with-no-api). For these operations we have submitted feature requests and are waiting for their release.

### Operations With No API

* Customization Settings
* User Mappings
* API integrations on preconfigured applications, such as AWS SAML App.
* SAML Roles on AWS SAML App
* Hooking up inline token hooks (they can be created and managed but not flipped on)

## Terraform Application Authentication

Let’s say the aforementioned application uses OIDC to authenticate users via Okta. Let’s go through how that might look with Terraform.

First I created an init.tf file and added the basic Okta config necessary to get started.

provider okta {
  org_name  = "example"
  base_url  = "okta.com"
  api_token = "${data.vault_generic_secret.okta_token.data["value"]}"
}

data vault_generic_secret okta_token {
  path = "secret/my_okta_api_token"
}

After getting the basic provider configuration, I created an app.tf file and retrieved the Everyone group with our data source.

data okta_group everyone {
  name = "Everyone"
}


I then created our OIDC application for the Example corp web app. I plugged in the necessary config in order to authenticate their users with OIDC.

resource okta_oauth_app my_app {
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

  redirect_uris             = ["https://example.com/auth-callback"]
  post_logout_redirect_uris = ["https://example.com"]
  login_uri                 = "https://example.com"
  groups                    = ["${data.okta_group.everyone.id}"]
}

Next, I created an auth.tf file and grabbed the default auth server. This will allow me to add and associate some scopes and claims with this authorization server. Note: take a look at the staff claim. This is to illustrate the power of expressions to derive values which can be injected into the user’s JWT.


Great! I have an OIDC application setup with a basic authentication server. Next I set my sights on sign on and password policies. I wanted delineate my internal users from all other users. One great way to do this is a Group Rule. After getting this game plan, I created a group.tf file and add my group and group rule.


Next, I created a policy.tf file and dumped both of my policies.

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
  question_recovery             = "INACTIVE"
}

resource okta_policy_rule_password staff_pwd {
  policyid = "${okta_policy_password.staff_pwd.id}"
  priority = 1
  name     = "Staff Password Policy Rule"
  status   = "ACTIVE"
}


### Enabling your SSO on your application

Now that my application is all configured and ready to go, let’s consider another scenario. I want to expose SAML SSO to one of my customers.

I start by gathering our customer’s SAML details. This involves their issuer URI, signature certificate, and their SSO URL. Then create an idp.tf file and add the following:

locals {
  sso_url = "http://www.example.com/sso/saml"
  issuer  = "http://www.okta.com/exk1fkpgv8uM7km3w1d8"
}

data local_file cert {
  filename = "${path.module}/certificate/cert.pem"
}

I can leverage Okta’s IdP to connect our customer’s SAML app to our application.
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


Next I can output the information from the IdP I created. We will need to provide it to our customer. They will use it to configure their SAML application.


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


Next I will configure an IdP discovery policy that will allow my customer to login to my application using Okta’s widget. This is called SP-initiated login, as opposed to IdP login, which starts at your customer’s SAML application. Okta breaks this down further here.

data okta_policy test {
  name = "Idp Discovery Policy"
  type = "IDP_DISCOVERY"
}

resource okta_policy_rule_idp_discovery discovery {
  policyid             = "${data.okta_policy.test.id}"
  priority             = 1
  name                 = "Customer"
  idp_type             = "SAML2"
  idp_id               = "${okta_idp_saml.test.id}"
  user_identifier_type = "IDENTIFIER"

  user_identifier_patterns {
    match_type = "SUFFIX"
    value      = "example.com"
  }
}

