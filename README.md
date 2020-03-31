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
    instanceType: m5.large
    desiredCapacity: 5
    volumeSize: 120
    iam:
      withAddonPolicies:
        albIngress: true
        autoScaler: true
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
--set git.path=cluster \
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
--set prometheus.enabled=true \
--set statusUpdateInterval=10s \
--set chartsSyncInterval=2m

helm repo add flagger https://flagger.app

helm upgrade -i flagger flagger/flagger --namespace fluxcd \
--set image.tag=master-3b04f12 \
--set meshProvider=kubernetes \
--set prometheus.install=true
```
