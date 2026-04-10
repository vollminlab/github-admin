terraform {
  required_version = ">= 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  cloud {
    organization = "vollminlab"
    workspaces {
      name = "github-admin"
    }
  }
}

provider "github" {
  owner = "vollminlab"
  token = var.github_token
}
