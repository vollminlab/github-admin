# ---------------------------------------------------------------------------
# k8s-vollminlab-cluster
# ---------------------------------------------------------------------------
resource "github_branch_protection" "k8s_main" {
  repository_id = "R_kgDON3iTuQ"
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

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# VMDeployTools
# ---------------------------------------------------------------------------
resource "github_branch_protection" "vmdeploytools_main" {
  repository_id = "VMDeployTools"
  pattern       = "main"

  required_status_checks {
    strict   = false
    contexts = ["Pester Unit Tests"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews = false
    required_approving_review_count = 0
  }

  enforce_admins = false
}

# ---------------------------------------------------------------------------
# github-admin
# ---------------------------------------------------------------------------
resource "github_branch_protection" "github_admin_main" {
  repository_id = "github-admin"
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["Terraform Plan"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins = true
}

# ---------------------------------------------------------------------------
# homelab-infrastructure
# ---------------------------------------------------------------------------
resource "github_branch_protection" "homelab_infrastructure_main" {
  repository_id = "homelab-infrastructure"
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins = true
}

# ---------------------------------------------------------------------------
# pihole-flask-api
# ---------------------------------------------------------------------------
resource "github_branch_protection" "pihole_flask_api_main" {
  repository_id = "pihole-flask-api"
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["test (3.11)", "test (3.12)"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins = true
}
