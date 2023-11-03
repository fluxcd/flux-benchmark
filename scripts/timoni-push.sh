#!/usr/bin/env bash

set -o errexit

repo_root=$(git rev-parse --show-toplevel)

timoni mod push $repo_root/timoni/modules/flux-hr-bench oci://localhost:5555/modules/flux-hr-bench -v 1.0.0
