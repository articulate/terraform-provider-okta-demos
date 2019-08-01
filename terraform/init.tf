// Loading everything from the environment
provider okta {}

provider aws {}

terraform {
  backend "s3" {
    bucket                  = "terraform-state-689543204258-us-east-1"
    key                     = "terraform-provider-okta-demos/terraform.tfstate"
    region                  = "us-east-1"
    shared_credentials_file = "/root/.aws/creds"
  }
}
