#!/usr/bin/env bash

set -o errexit

: ${1?"Usage: $0 <NUMBER OF RELEASES>"}

COUNT=$1
NAMESPACE=test
REPO_ROOT=$(git rev-parse --show-toplevel)
TEST_DIR="${REPO_ROOT}/cluster/${NAMESPACE}"

mkdir -p ${TEST_DIR}

for i in $(seq -f "%05g" 1 $COUNT)
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

