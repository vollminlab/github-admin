# Adding a New Repo to github-admin

## Steps

**1. Add the repository resource** in `terraform/main.tf`:

```hcl
resource "github_repository" "my_new_repo" {
  name                   = "my-new-repo"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_wiki               = false
}
```

**2. Add branch protection** in `terraform/main.tf`:

```hcl
resource "github_branch_protection" "my_new_repo_main" {
  repository_id = github_repository.my_new_repo.node_id
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    enforce_admins        = true
  }

  required_conversation_resolution = true
  enforce_admins                    = true

  # Add required status checks if the repo has CI:
  required_status_checks {
    strict   = false
    contexts = ["test"]   # must match exact CI job name
  }
}
```

**3. Import existing resources** if the repo already exists on GitHub (Terraform doesn't create it — it imports):

```bash
cd terraform
terraform import github_repository.my_new_repo my-new-repo
terraform import github_branch_protection.my_new_repo_main <node_id>:main
```

Get the node ID from GitHub's GraphQL API or `gh api repos/vollminlab/my-new-repo --jq .node_id`.

**4. Open a PR** — the CI plan will show exactly what Terraform will change. Review it, merge, and the protection goes live automatically.

## Finding the exact CI job name

Required status check `contexts` must match the GitHub Actions job name exactly (including matrix suffixes). Check the repo's workflow file:

```yaml
jobs:
  test:           # ← this is "test"
    strategy:
      matrix:
        python: ["3.11", "3.12"]
    # matrix jobs appear as "test (3.11)" and "test (3.12)"
```

If CI hasn't run yet on the new repo, you can add the protection without `required_status_checks` first, then add the checks in a follow-up PR once CI is confirmed working.

## Troubleshooting

**Terraform plan shows drift on existing resources:**
The repo may have been manually configured in the GitHub UI. Import the current state before applying to avoid conflicts.

**`terraform apply` fails with 422:**
The branch protection rule references a CI job that doesn't exist in the repo's workflows. Check the exact job name.

**ARC runner not picking up the workflow:**
Check that the self-hosted runner is online: `kubectl get runners -n actions-runner-system`.
