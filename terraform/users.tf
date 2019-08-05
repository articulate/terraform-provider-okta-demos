module jane_doe {
  source     = "./user"
  bio        = "I am wonderful"
  email      = "janedoe@example.com"
  first_name = "Jane"
  last_name  = "Doe"

  admin_roles = ["SUPER_ADMIN"]
  groups      = ["${okta_group.staff.id}"]
}

module john_doe {
  source     = "./user"
  bio        = "I am terrific"
  email      = "johndoe@example.com"
  first_name = "John"
  last_name  = "Doe"

  admin_roles = ["SUPER_ADMIN"]
  groups      = ["${okta_group.staff.id}"]
}

resource okta_user andy {
  email      = "andygertjejansen@gmail.com"
  login      = "andygertjejansen@gmail.com"
  first_name = "Andy"
  last_name  = "Gertjejansen"
}

resource okta_user_schema bio {
  index       = "bio"
  title       = "bio"
  type        = "string"
  permissions = "HIDE"
  master      = "OKTA"
}
