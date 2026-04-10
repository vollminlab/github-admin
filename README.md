# github-admin

Centralized GitHub repository administration for the Vollminlab homelab, managed via Terraform and GitOps.

## What this repo does

This repo manages GitHub branch protection rules across all Vollminlab repos using Terraform. Changes to branch protection go through a pull request, which runs a `terraform plan` to show exactly what will change in GitHub before anything is applied. On merge, `terraform apply` runs automatically.

## Repos managed

| Repo | Protection | Required checks |
|---|---|---|
| `k8s-vollminlab-cluster` | PR required, enforce admins, conversation resolution | Security Scan, Validate Kubernetes Manifests, Kyverno Policy Validation, Integration Test |
| `VMDeployTools` | PR required | Pester Unit Tests |
| `github-admin` | PR required, enforce admins | Terraform Plan |
| `homelab-infrastructure` | PR required, enforce admins | None (no CI) |
| `pihole-flask-api` | PR required, enforce admins | test (3.11), test (3.12) |

## How it works

### CI workflows

| Workflow | Trigger | What it does |
|---|---|---|
| `Terraform Plan` | Pull request → main | Runs `terraform plan` and shows what would change in GitHub |
| `Terraform Apply` | Push → main (i.e. PR merged) | Runs `terraform apply` to make the changes live |

### Secrets management

No secrets are stored in GitHub. Both workflows use the [1Password GitHub Actions integration](https://github.com/1Password/load-secrets-action) to retrieve secrets at runtime using the `Github-Admin-CI` 1Password service account:

- **GitHub PAT** — `op://Homelab/Github-Multipurpose-PAT/password` — used by Terraform to manage branch protection
- **Minio access key** — `op://Homelab/Minio-Terraform-Github-Admin/username` — used to authenticate to the Terraform state backend
- **Minio secret key** — `op://Homelab/Minio-Terraform-Github-Admin/credential` — used to authenticate to the Terraform state backend

### Terraform state

State is stored remotely in a Minio S3-compatible bucket at `s3.vollminlab.com`, in the `terraform-state` bucket under the key `github-admin/terraform.tfstate`. Versioning is enabled on the bucket so previous state files can be recovered if needed.

## Making changes

1. Create a branch and edit `terraform/main.tf`
2. Open a PR — the `Terraform Plan` check will run and show the diff
3. Review the plan output in the PR checks
4. Merge — `Terraform Apply` runs automatically

## Adding a new repo

Add a `github_branch_protection` resource to `terraform/main.tf`:

```hcl
resource "github_branch_protection" "my_repo_main" {
  repository_id = "my-repo"
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins = true
}
```

If the repo already has branch protection applied outside of Terraform, import it first:

```bash
terraform import \
  -var="github_token=$(op read 'op://Homelab/Github-Multipurpose-PAT/password')" \
  github_branch_protection.my_repo_main <REPO_NODE_ID>:main
```

Then run `terraform plan` locally to verify zero diff before opening a PR.

## Local development

Requirements: `terraform`, `op` (1Password CLI)

```bash
cd terraform
terraform init \
  -backend-config="access_key=$(op read 'op://Homelab/Minio-Terraform-Github-Admin/username')" \
  -backend-config="secret_key=$(op read 'op://Homelab/Minio-Terraform-Github-Admin/credential')"

terraform plan -var="github_token=$(op read 'op://Homelab/Github-Multipurpose-PAT/password')"
```
