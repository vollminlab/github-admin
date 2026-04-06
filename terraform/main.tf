# ---------------------------------------------------------------------------
# k8s-vollminlab-cluster
# ---------------------------------------------------------------------------
resource "github_branch_protection" "k8s_main" {
  repository_id = "k8s-vollminlab-cluster"
  pattern       = "main"

  required_status_checks {
    strict   = false
    contexts = [
      "Security Scan",
      "Validate Kubernetes Manifests",
      "Kyverno Policy Validation",
      "Integration Test",
    ]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews = false
    required_approving_review_count = 0
  }

  enforce_admins = false
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
# homelab-infrastructure  (no CI — protect against direct force-pushes only)
# ---------------------------------------------------------------------------
resource "github_branch_protection" "homelab_infra_main" {
  repository_id = "homelab-infrastructure"
  pattern       = "main"

  enforce_admins = false
}

# ---------------------------------------------------------------------------
# pihole-flask-api  (no CI yet — basic protection)
# ---------------------------------------------------------------------------
resource "github_branch_protection" "pihole_flask_api_main" {
  repository_id = "pihole-flask-api"
  pattern       = "main"

  enforce_admins = false
}
