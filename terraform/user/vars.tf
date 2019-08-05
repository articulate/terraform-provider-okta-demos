variable "admin_roles" {
  type    = "list"
  default = []
}

variable bio {
  default = ""
}

variable "division" {
  default = ""
}

variable "email" {}

variable "enabled" {
  default = true
}

variable "first_name" {}

variable "groups" {
  type = "list"
}

variable "last_name" {}

// Defaults to email when not present
variable "login" {
  default = ""
}

variable "manager" {
  default = ""
}

variable "mobile_phone" {
  default = ""
}

variable "organization" {
  default = ""
}

variable "title" {
  default = ""
}

output "email" {
  value = "${okta_user.user.*.email}"
}

output "id" {
  value = "${okta_user.user.*.id}"
}
