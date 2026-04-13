#!/usr/bin/env bash
# Add a new repo to Terraform management.
#
# Usage:
#   ./scripts/add-repo.sh <repo-name> [required-check-1] [required-check-2] ...
#
# Examples:
#   ./scripts/add-repo.sh my-new-repo
#   ./scripts/add-repo.sh my-api-repo "test (3.11)" "test (3.12)"
#
# The script:
#   1. Queries the GitHub API for repo metadata (description, settings)
#   2. Generates the Terraform import + resource + branch_protection blocks
#   3. Appends them to terraform/main.tf
#
# Required status check names must exactly match the CI job names (including
# matrix suffixes). Run `gh run list` or check the workflow YAML for job names.
#
# All applies go through CI — never apply locally.

set -euo pipefail

REPO_NAME="${1:-}"
if [ -z "$REPO_NAME" ]; then
  echo "Usage: $0 <repo-name> [required-check-1] [required-check-2] ..." >&2
  exit 1
fi
shift
REQUIRED_CHECKS=("$@")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_TF="$SCRIPT_DIR/../terraform/main.tf"
ORG="vollminlab"

# Derive Terraform resource name (dashes → underscores)
TF_NAME="${REPO_NAME//-/_}"

# Check for duplicates
if grep -q "\"github_repository\" \"${TF_NAME}\"" "$MAIN_TF"; then
  echo "Error: resource github_repository.${TF_NAME} already exists in main.tf" >&2
  exit 1
fi

echo "Fetching repo metadata from GitHub..."
REPO_JSON=$(gh repo view "${ORG}/${REPO_NAME}" \
  --json name,description,hasIssuesEnabled,hasProjectsEnabled,hasWikiEnabled,isPrivate 2>/dev/null) || {
  echo "Error: repo ${ORG}/${REPO_NAME} not found on GitHub. Create it first." >&2
  exit 1
}

DESCRIPTION=$(echo "$REPO_JSON" | jq -r '.description // ""')
HAS_ISSUES=$(echo "$REPO_JSON"  | jq -r 'if .hasIssuesEnabled  then "true" else "false" end')
HAS_PROJECTS=$(echo "$REPO_JSON" | jq -r 'if .hasProjectsEnabled then "true" else "false" end')
HAS_WIKI=$(echo "$REPO_JSON"    | jq -r 'if .hasWikiEnabled     then "true" else "false" end')
IS_PRIVATE=$(echo "$REPO_JSON"  | jq -r '.isPrivate')

if [ "$IS_PRIVATE" = "true" ]; then
  echo "Warning: ${ORG}/${REPO_NAME} is private. Branch protection requires a public repo on the free plan." >&2
  echo "Make it public first, or branch protection will fail to apply." >&2
fi

# Build required_status_checks block (only if checks were provided)
STATUS_CHECKS_BLOCK=""
if [ ${#REQUIRED_CHECKS[@]} -gt 0 ]; then
  CONTEXTS=""
  for check in "${REQUIRED_CHECKS[@]}"; do
    CONTEXTS+="      \"${check}\","$'\n'
  done
  CONTEXTS="${CONTEXTS%,$'\n'}"  # strip trailing comma from last entry
  STATUS_CHECKS_BLOCK=$(cat <<HEREDOC

  required_status_checks {
    strict   = true
    contexts = [
${CONTEXTS}
    ]
  }
HEREDOC
)
fi

# Append to main.tf
cat >> "$MAIN_TF" <<HEREDOC

# ---------------------------------------------------------------------------
# ${REPO_NAME}
# ---------------------------------------------------------------------------
import {
  to = github_repository.${TF_NAME}
  id = "${REPO_NAME}"
}

resource "github_repository" "${TF_NAME}" {
  name                   = "${REPO_NAME}"
  description            = "${DESCRIPTION}"
  delete_branch_on_merge = true
  has_issues             = ${HAS_ISSUES}
  has_projects           = ${HAS_PROJECTS}
  has_wiki               = ${HAS_WIKI}
}

resource "github_branch_protection" "${TF_NAME}_main" {
  repository_id = github_repository.${TF_NAME}.node_id
  pattern       = "main"
${STATUS_CHECKS_BLOCK}
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  enforce_admins                  = true
  require_conversation_resolution = true
}
HEREDOC

echo "Added ${REPO_NAME} to terraform/main.tf"
echo "Next steps:"
echo "  1. Review the new block at the bottom of terraform/main.tf"
echo "  2. Commit and push to a feature branch"
echo "  3. Open a PR — CI will run terraform plan and post the diff"
