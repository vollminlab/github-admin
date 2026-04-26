# github-admin — Overview

## What this repo does

Manages GitHub organization configuration for `vollminlab` as Infrastructure as Code using Terraform. All changes to branch protection, required status checks, and repository settings go through this repo — never manually in the GitHub UI.

## What's managed

### Branch protection (all repos)

Every managed repo enforces:
- PRs required to merge to `main` (no direct pushes)
- Admins subject to the same rules (no bypass)
- Stale reviews dismissed on new commits
- All conversations must be resolved before merge
- Branch deleted automatically after merge

### Per-repo required status checks

| Repo | Required checks before merge |
|------|------------------------------|
| `k8s-vollminlab-cluster` | Security Scan, Validate Kubernetes Manifests, Kyverno Policy Validation, Integration Test |
| `VMDeployTools` | Pester Unit Tests |
| `github-admin` | Terraform Plan |
| `homelab-infrastructure` | *(none — plan/apply is the gate)* |
| `pihole-flask-api` | test (Python 3.11), test (Python 3.12) |

## How changes work

```
Edit terraform/main.tf
        │
        └──► Open PR
                │
                └──► CI runs terraform plan (shows what will change)
                            │
                            └──► PR merged to main
                                        │
                                        └──► CI runs terraform apply (changes go live)
```

Plan output is posted as a PR comment so reviewers can see the exact GitHub API changes before approving.

## Secrets and auth

No secrets are stored in the repo or in GitHub secrets. All credentials are fetched at runtime from 1Password via the ARC runner:

- **GitHub token**: `op://Homelab/Github-Admin-Token/password`
- **Terraform Cloud token**: `op://Homelab/Terraform-Cloud-Token/credential`

State is stored remotely in HCP Terraform Cloud (vollminlab org, github-admin workspace).

## CI runner

Both workflows run on the `vollminlab` self-hosted ARC runner (Actions Runner Controller in the k8s cluster). The runner needs network access to GitHub and HCP Terraform Cloud.

## Adding a new repo

See [[github-admin-adding-repos]] for the step-by-step procedure.
