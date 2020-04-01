#!/usr/bin/env sh

set -o errexit

: ${1?"Usage: $0 <NUMBER OF RELEASES>"}

COUNT=$1
NAMESPACE=test
REPO=https://github.com/stefanprodan/gitops-benchmark
REPO_ROOT=$(git rev-parse --show-toplevel)
TEST_DIR="${REPO_ROOT}/cluster/${NAMESPACE}"

mkdir -p ${TEST_DIR}

for i in $(seq -f "%05g" 1 $COUNT)
do

cat << EOF | tee ${TEST_DIR}/app-${i}.yaml > /dev/null
apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: app-${i}
  namespace: ${NAMESPACE}
spec:
  releaseName: app-${i}
  chart:
    git: ${REPO}
    ref: master
    path: charts/podinfo
EOF

done

cat << EOF | tee ${TEST_DIR}/namespace.yaml > /dev/null
apiVersion: v1
kind: Namespace
metadata:
  name: test
EOF

cd ${TEST_DIR} && rm -f kustomization.yaml && kustomize create --autodetect
