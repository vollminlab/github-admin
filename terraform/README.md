# github-admin Terraform

Manages GitHub branch protection rules for all `svollmi1` repos.

## Usage

```bash
cd terraform
export TF_VAR_github_token=$(op read "op://Homelab/Github-Multipurpose-PAT/password")
terraform init
terraform plan
terraform apply
```

## Repos managed

| Repo | Required checks |
|------|----------------|
| `k8s-vollminlab-cluster` | Security Scan, Validate Kubernetes Manifests, Kyverno Policy Validation, Integration Test |
| `VMDeployTools` | Pester Unit Tests |
| `homelab-infrastructure` | *(none — push protection only)* |
| `pihole-flask-api` | *(none — push protection only)* |

## Importing existing protection

If protection already exists (e.g. k8s was managed by the old local Terraform), import first:

```bash
terraform import github_branch_protection.k8s_main k8s-vollminlab-cluster:main
```
