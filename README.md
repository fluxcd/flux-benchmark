# gitops-benchmark

Flux, Helm Operator and Flagger benchmark

## Cluster 

```bash
cat << EOF | eksctl create cluster -p sts -f -
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: gitops-benchmark
  region: eu-west-1
  version: "1.15"
managedNodeGroups:
  - name: default
    # 58 pods per node
    instanceType: c5.xlarge 
    desiredCapacity: 5
    volumeSize: 120
EOF

helm upgrade -i metrics-server stable/metrics-server \
--namespace kube-system \
--set args[0]=--kubelet-preferred-address-types=InternalIP
```

## Operators

```bash
helm repo add fluxcd https://charts.fluxcd.io

kubectl create namespace fluxcd
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml

helm upgrade -i flux fluxcd/flux --namespace fluxcd \
--set image.repository=fluxcd/flux-prerelease \
--set image.tag=master-98602df4-wip \
--set git.readonly=true \
--set registry.disableScanning=true \
--set prometheus.enabled=true \
--set syncGarbageCollection.enabled=true \
--set manifestGeneration=true \
--set sync.state=secret \
--set sync.interval=2m \
--set git.pollInterval=2m \
--set git.url=https://github.com/stefanprodan/gitops-benchmark

helm upgrade -i helm-operator fluxcd/helm-operator --namespace fluxcd \
--set image.repository=fluxcd/helm-operator-prerelease \
--set image.tag=master-706bcb34 \
--set helm.versions=v3 \
--set git.ssh.secretName=flux-git-deploy \
--set service.type=LoadBalancer \
--set prometheus.enabled=true \
--set statusUpdateInterval=30s \
--set chartsSyncInterval=3m

helm repo add flagger https://flagger.app

helm upgrade -i flagger flagger/flagger --namespace fluxcd \
--set image.tag=master-7c00e5b \
--set meshProvider=kubernetes \
--set prometheus.install=true

helm upgrade -i helm-tester flagger/loadtester --namespace fluxcd \
--set fullnameOverride=helm-tester \
--set image.tag=0.15.0 \
--set serviceAccountName=helm-operator

helm upgrade -i grafana ./charts/grafana --namespace fluxcd  \
--set service.type=LoadBalancer \
--set url=http://flagger-prometheus:9090
```

## Benchmark

Deploy 100 helm releases:

```bash
export HRS=100

cat << EOF | tee .flux.yaml
version: 1
commandUpdated:
  generators:
    - command: scripts/gen-hrs.sh ${HRS}
EOF

git add -A &&
git commit -m "Benchmark ${HRS} releases" &&
git push &&
fluxctl sync --k8s-fwd-ns fluxcd
```
