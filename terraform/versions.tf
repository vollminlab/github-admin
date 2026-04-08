terraform {
  required_version = ">= 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "github-admin/terraform.tfstate"
    region                      = "us-east-1"
    endpoints = {
      s3 = "https://s3.vollminlab.com"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}

provider "github" {
  owner = "svollmi1"
  token = var.github_token
}
