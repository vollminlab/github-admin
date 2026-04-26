# CLAUDE.md — github-admin

Terraform-managed GitHub organization configuration for `vollminlab`. All branch protection and repo settings are IaC — never change them in the GitHub UI.

## What this repo manages

Branch protection and repository settings for 5 repos via the `integrations/github` Terraform provider. State is stored in HCP Terraform Cloud.

**CI workflow:** PRs trigger `terraform plan` (shows diff as comment). Merge triggers `terraform apply`.

## Hard constraints

- Never apply Terraform locally — all applies go through CI on merge to main
- Never manually configure branch protection in the GitHub UI — it will conflict with Terraform state
- Required status check names must exactly match the CI job name (including matrix suffixes like `test (3.11)`)

## Key files

| File | Purpose |
|------|---------|
| `terraform/main.tf` | All repo and branch protection resources |
| `terraform/versions.tf` | Provider versions + HCP Terraform backend config |
| `.github/workflows/plan.yml` | Runs on PR — posts terraform plan output |
| `.github/workflows/apply.yml` | Runs on merge to main — applies changes |

## Secrets (all via 1Password, fetched by ARC runner)

- `op://Homelab/Github-Admin-Token/password` — GitHub fine-grained PAT (repository `Administration: read/write`, `Metadata: read`)
- `op://Homelab/Terraform-Cloud-Token/credential` — HCP Terraform API token

## Adding a repo

See `docs/adding-repos.md`.

## CI runner

Self-hosted ARC runner in the k8s cluster. Check health:
```bash
kubectl get runners -n actions-runner-system
```
