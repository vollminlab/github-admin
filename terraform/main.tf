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
    strict = true
    contexts = [
      "Security Scan",
      "Validate Kubernetes Manifests",
      "Validate Terraform Modules",
      "Kyverno Policy Validation",
      "Integration Test",
      # gitleaks. Was never in this list, so a PR with a failing secret scan has
      # always been mergeable — observed on k8s PR #1065. Runs on
      # ${{ vars.CI_RUNNER || 'vollminlab' }}, so it shares the existing ARC
      # escape hatch and adds no new way to deadlock merges.
      "Secret Scanning",
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

# ---------------------------------------------------------------------------
# homelab-obsidian-vault
# ---------------------------------------------------------------------------
import {
  to = github_repository.homelab_obsidian_vault
  id = "homelab-obsidian-vault"
}

resource "github_repository" "homelab_obsidian_vault" {
  name                   = "homelab-obsidian-vault"
  description            = "Obsidian vault for vollminlab homelab documentation"
  visibility             = "public"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = false
  has_wiki               = false
}

resource "github_branch_protection" "homelab_obsidian_vault_main" {
  repository_id = github_repository.homelab_obsidian_vault.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["Secret Scanning"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# shlink-ingress-controller
# ---------------------------------------------------------------------------
import {
  to = github_repository.shlink_ingress_controller
  id = "shlink-ingress-controller"
}

resource "github_repository" "shlink_ingress_controller" {
  name                   = "shlink-ingress-controller"
  description            = "Kubernetes controller that auto-creates Shlink short links from Ingress annotations"
  visibility             = "public"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_wiki               = false
}

resource "github_branch_protection" "shlink_ingress_controller_main" {
  repository_id = github_repository.shlink_ingress_controller.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["Test"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# masters-league
# ---------------------------------------------------------------------------
import {
  to = github_repository.masters_league
  id = "masters-league"
}

resource "github_repository" "masters_league" {
  name                   = "masters-league"
  description            = "Masters Tournament leaderboard and scorecard viewer for a fantasy golf league"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_wiki               = false
}

# No required_status_checks: the only workflow here (build.yml) triggers on
# `v*` tags, not pull_request, so there is no check that could ever report on a
# PR. Requiring one would block every merge permanently. Give this repo a
# PR-triggered CI workflow first, then add its context here.
resource "github_branch_protection" "masters_league_main" {
  repository_id = github_repository.masters_league.node_id
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# ansible-playbooks
# ---------------------------------------------------------------------------
import {
  to = github_repository.ansible_playbooks
  id = "ansible-playbooks"
}

resource "github_repository" "ansible_playbooks" {
  name                   = "ansible-playbooks"
  description            = "Ansible playbooks for Vollminlab infrastructure automation"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_wiki               = false
}

resource "github_branch_protection" "ansible_playbooks_main" {
  repository_id = github_repository.ansible_playbooks.node_id
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# groupme_exporter
# ---------------------------------------------------------------------------
import {
  to = github_repository.groupme_exporter
  id = "groupme_exporter"
}

resource "github_repository" "groupme_exporter" {
  name                   = "groupme_exporter"
  description            = "Pulls all messages from a groupme chat into a sqlite database as a daemon service"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_wiki               = false
}

resource "github_branch_protection" "groupme_exporter_main" {
  repository_id = github_repository.groupme_exporter.node_id
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# longhorn-rebalancing-controller
# ---------------------------------------------------------------------------
import {
  to = github_repository.longhorn_rebalancing_controller
  id = "longhorn-rebalancing-controller"
}

resource "github_repository" "longhorn_rebalancing_controller" {
  name                   = "longhorn-rebalancing-controller"
  description            = "A custom Go controller to better balance longhorn volume allocation across kubernetes worker nodes"
  visibility             = "public"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_wiki               = false
}

resource "github_branch_protection" "longhorn_rebalancing_controller_main" {
  repository_id = github_repository.longhorn_rebalancing_controller.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["Test"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# vollmint
# ---------------------------------------------------------------------------
import {
  to = github_repository.vollmint
  id = "vollmint"
}

resource "github_repository" "vollmint" {
  name                   = "vollmint"
  description            = "Household budget tracker (SimpleFIN + Venmo CSV ingestion)"
  visibility             = "public"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_wiki               = false
}

resource "github_branch_protection" "vollmint_main" {
  repository_id = github_repository.vollmint.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["Go Tests", "Web Tests"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}

# ---------------------------------------------------------------------------
# clipbridge
# ---------------------------------------------------------------------------
resource "github_repository" "clipbridge" {
  name                   = "clipbridge"
  description            = "Paste a Windows screenshot straight into a remote Claude Code session over SSH"
  visibility             = "public"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_wiki               = false
}

resource "github_branch_protection" "clipbridge_main" {
  repository_id = github_repository.clipbridge.node_id
  pattern       = "main"

  required_status_checks {
    strict = true
    # Read verbatim from the API, not guessed:
    #   gh api repos/vollminlab/clipbridge/commits/main/check-runs -q '.check_runs[].name'
    # A context matching no real check blocks every PR forever, and enforce_admins
    # leaves no bypass.
    contexts = [
      "shell (shellcheck, dash, busybox ash)",
      "pester (windows)",
      "dotnet-core (linux)",
      "dotnet-win32 (windows, AOT publish)",
    ]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}
