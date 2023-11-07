#!/usr/bin/env bash

set -o errexit

repo_root=$(git rev-parse --show-toplevel)

kubectl label node flux-worker role=flux --overwrite
kubectl taint nodes flux-worker role=flux:NoSchedule --overwrite

flux install --manifests $repo_root/manifests/install
