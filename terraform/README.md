# github-admin Terraform

Manages GitHub branch protection rules for all `vollminlab` repos.

## Local development (plan only — never apply locally)

All applies run through CI on merge to `main`. Local usage is for validating changes before opening a PR.

```bash
cd terraform
terraform init \
  -backend-config="access_key=$(op read 'op://Homelab/Minio-Terraform-Github-Admin/username')" \
  -backend-config="secret_key=$(op read 'op://Homelab/Minio-Terraform-Github-Admin/credential')"

terraform plan -var="github_token=$(op read 'op://Homelab/Github-Admin-Token/password')"
```

## Repos managed

| Repo | Required checks |
|------|----------------|
| `k8s-vollminlab-cluster` | Security Scan, Validate Kubernetes Manifests, Kyverno Policy Validation, Integration Test |
| `VMDeployTools` | Pester Unit Tests |
| `github-admin` | Terraform Plan |
| `homelab-infrastructure` | *(none)* |
| `pihole-flask-api` | test (3.11), test (3.12) |
| `homelab-obsidian-vault` | *(none)* |
| `shlink-ingress-controller` | *(none)* |
| `masters-league` | *(none)* |
| `groupme_exporter` | *(none)* |

## Importing existing protection

If protection already exists outside of Terraform, import it first:

```bash
terraform import \
  -var="github_token=$(op read 'op://Homelab/Github-Admin-Token/password')" \
  github_branch_protection.k8s_main <REPO_NODE_ID>:main
```
