variable "gh_token" {
  description = "Token for authenticating with GitHub"
  type = string
}

variable "environments" {
  type = map(object({
    name = string
  }))

  default = {
    "demo" = {
      name = "demo"
    }

    "test" = {
      name = "test"
    }

    "dev" = {
      name = "dev"
    }
  }
}
