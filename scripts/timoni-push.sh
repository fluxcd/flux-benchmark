#!/usr/bin/env bash

set -o errexit

repo_root=$(git rev-parse --show-toplevel)

timoni mod push $repo_root/timoni/modules/flux-hr-bench oci://localhost:5555/modules/flux-hr-bench -v 1.0.0
timoni mod push $repo_root/timoni/modules/flux-ks-bench oci://localhost:5555/modules/flux-ks-bench -v 1.0.0
timoni artifact push oci://localhost:5555/manifests/podinfo -f $repo_root/manifests/podinfo -t 1.0.0 -t latest
