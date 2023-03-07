#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail


echo TREE_GIT_SHA "$(./scripts/git-tree-hash.sh)"
echo COMMIT_GIT_SHA "$(git rev-parse --verify HEAD)"