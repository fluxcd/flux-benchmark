#!/usr/bin/env bash

set -o errexit

: ${1?"Usage: $0 <NUMBER OF RELEASES>"}

COUNT=$1
NAMESPACE=test
REPO=https://github.com/stefanprodan/gitops-benchmark

if [ $COUNT -gt 0 ]
then

for i in $(seq -w 1 $COUNT)
do

cat << EOF
---
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
fi

cat << EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
EOF
