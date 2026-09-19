#!/usr/bin/env bash
set -euo pipefail

npm ci --prefer-offline
action="$(yq -er '.jobs.build.steps[] | select(.id == "super_linter") | .uses' .github/workflows/super-linter.yml)"
if [[ ! "$action" =~ ^super-linter/super-linter/slim@([[:xdigit:]]{40})$ ]]; then
  echo "Expected the super_linter step to use Super Linter slim pinned to a commit." >&2
  exit 1
fi

# Read the image from the pinned action instead of its optional version comment.
action_ref="${BASH_REMATCH[1]}"
image="$(curl --fail --silent --show-error --location \
  "https://raw.githubusercontent.com/super-linter/super-linter/${action_ref}/slim/action.yml" |
  yq -er '.runs.image')"
if [[ "$image" != docker://ghcr.io/super-linter/super-linter:* ]]; then
  echo "Expected the pinned action to declare a Super Linter Docker image." >&2
  exit 1
fi

container_path="$(docker run --rm --entrypoint /bin/sh "${image#docker://}" -c 'printf "%s" "$PATH"')"
# Keep the container PATH scoped to the linter, leaving later host steps intact.
printf 'path=/github/workspace/node_modules/.bin:%s\n' "$container_path" >>"$GITHUB_OUTPUT"
