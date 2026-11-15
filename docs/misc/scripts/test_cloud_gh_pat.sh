#!/bin/sh
###
# Created using: GPT-6.1 Sol (Medium)
# Human verification: Basic testing done.
# Description: Test Github API access with PAT.
###

# Exit on unhandled command failures and unset variable expansions.
set -o errexit -o nounset

# Require a nonempty HTTP-secret binding.
# -z tests for an empty string; :- supplies an empty default if unset.
if [ -z "${ZID_GH_PROXY_PAT:-}" ]; then
    echo "Error: ZID_GH_PROXY_PAT is unset or empty." >&2
    exit 1
fi

# Check that gh is available.
# command -v locates the command; discard its output.
if ! command -v gh >/dev/null 2>&1; then
    echo "Error: GitHub CLI (gh) is not installed." >&2
    exit 1
fi

# Pass the secret placeholder as GH_TOKEN for this command only.
# The proxy substitutes the real PAT for the configured HTTPS destination.
# --jq extracts the authenticated account's login from the API response.
GH_TOKEN="$ZID_GH_PROXY_PAT" gh api user --jq .login
