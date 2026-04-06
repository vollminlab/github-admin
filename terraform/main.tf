# ---------------------------------------------------------------------------
# k8s-vollminlab-cluster
# ---------------------------------------------------------------------------
# TODO: migrate from k8s-vollminlab-cluster/terraform/github-branch-protection/
# Current protection (managed there): strict=true, enforce_admins=true,
# require_conversation_resolution=true, checks: Security Scan, Validate
# Kubernetes Manifests, Kyverno Policy Validation, Integration Test.
# Import with: terraform import github_branch_protection.k8s_main R_kgDON3iTuQ:main
# Then remove the local Terraform in that repo.

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
# homelab-infrastructure
# ---------------------------------------------------------------------------
# Branch protection requires GitHub Pro for private repos — skipping.
# Repo is private; upgrade account or make public to enable protection.

# ---------------------------------------------------------------------------
# pihole-flask-api  (no CI yet — basic protection)
# ---------------------------------------------------------------------------
resource "github_branch_protection" "pihole_flask_api_main" {
  repository_id = "pihole-flask-api"
  pattern       = "main"

  enforce_admins = false
}
