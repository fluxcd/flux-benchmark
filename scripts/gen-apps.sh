#!/usr/bin/env bash

set -o errexit

: ${1?"Usage: $0 <NAMESPACE>"}

NAMESPACE=$1
REPO_ROOT=$(git rev-parse --show-toplevel)
TEST_DIR="${REPO_ROOT}/cluster/${NAMESPACE}"

mkdir -p ${TEST_DIR}

for i in {1..10}
do

cat << EOF | tee ${TEST_DIR}/app-${i}.yaml
apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: app-${i}
  namespace: ${NAMESPACE}
spec:
  releaseName: app-${i}
  chart:
    git: https://github.com/stefanprodan/gitops-benchmark
    ref: master
    path: charts/podinfo
EOF

done

