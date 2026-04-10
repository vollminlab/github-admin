# ---------------------------------------------------------------------------
# k8s-vollminlab-cluster
# ---------------------------------------------------------------------------
resource "github_repository" "k8s" {
  name                   = "k8s-vollminlab-cluster"
  description            = "A GitOps-managed Kubernetes cluster configuration"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_wiki               = true
}

resource "github_branch_protection" "k8s_main" {
  repository_id = github_repository.k8s.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = [
      "Security Scan",
      "Validate Kubernetes Manifests",
      "Kyverno Policy Validation",
      "Integration Test",
    ]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# VMDeployTools
# ---------------------------------------------------------------------------
resource "github_repository" "vmdeploytools" {
  name                   = "VMDeployTools"
  description            = "PowerShell module for automated VM deployment in VMware vSphere"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
}

resource "github_branch_protection" "vmdeploytools_main" {
  repository_id = github_repository.vmdeploytools.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["Pester Unit Tests"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# github-admin
# ---------------------------------------------------------------------------
resource "github_repository" "github_admin" {
  name                   = "github-admin"
  description            = "Terraform for GitHub repository and branch protection management"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
}

resource "github_branch_protection" "github_admin_main" {
  repository_id = github_repository.github_admin.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["Terraform Plan"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# homelab-infrastructure
# ---------------------------------------------------------------------------
resource "github_repository" "homelab_infrastructure" {
  name                   = "homelab-infrastructure"
  description            = "Source-of-truth for Vollminlab infrastructure configuration"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
}

resource "github_branch_protection" "homelab_infrastructure_main" {
  repository_id = github_repository.homelab_infrastructure.node_id
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}


# ---------------------------------------------------------------------------
# pihole-flask-api
# ---------------------------------------------------------------------------
resource "github_repository" "pihole_flask_api" {
  name                   = "pihole-flask-api"
  description            = "A lightweight REST API for managing Pi-hole DNS A records."
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
}

resource "github_branch_protection" "pihole_flask_api_main" {
  repository_id = github_repository.pihole_flask_api.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["test (3.11)", "test (3.12)"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}
