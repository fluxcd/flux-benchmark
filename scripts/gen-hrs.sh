#!/usr/bin/env bash

set -o errexit

: ${1?"Usage: $0 <NUMBER OF RELEASES>"}

COUNT=$1
NAMESPACE=test

for i in $(seq -f "%05g" 1 $COUNT)
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

cat << EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
EOF
