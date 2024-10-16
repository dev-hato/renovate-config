#!/usr/bin/env bash

npm ci --prefer-offline
tag="$(grep super-linter/super-linter/slim .github/workflows/super-linter.yml | sed -e 's/^ *uses: //g' | sed -e 's;/slim@.* # ;:slim-;g')"
PATH="$(docker run --rm --entrypoint '' "ghcr.io/${tag}" /bin/sh -c 'echo $PATH')"
echo "PATH=/github/workspace/node_modules/.bin:${PATH}" >>"$GITHUB_ENV"
