# gitops-benchmark

Flux, Helm Operator and Flagger benchmark

## Cluster 

The benchmark was run on an EKS cluster with five [c5.xlarge](https://aws.amazon.com/ec2/instance-types/c5/) nodes:

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

The GitOps operators where installed with Helm v3:

```bash
kubectl create namespace fluxcd
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml

helm repo add fluxcd https://charts.fluxcd.io

helm upgrade -i flux fluxcd/flux --namespace fluxcd \
--set image.tag=1.19.0 \
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
--set workers=4 \
--set statusUpdateInterval=30s \
--set chartsSyncInterval=3m

helm repo add flagger https://flagger.app

helm upgrade -i flagger flagger/flagger --namespace fluxcd \
--set image.tag=1.0.0-rc.4 \
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

The helm install benchmark was performed by deploying 100 helm releases:

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

The helm upgrade for all 100 releases in-parallel was performed by changing the podinfo container image
in [values.yaml](https://github.com/stefanprodan/gitops-benchmark/blob/master/charts/podinfo/values.yaml#L27).

## Observations

* Helm Operator installs/upgrades 100 helm releases in 4 minutes with 5 to 10 seconds per release
* Helm Operator peaks around 250Mi of memory and 400m CPU cores when installing/upgrading
* Helm Operator peaks around 120Mi of memory and 60m CPU cores for dry-runs
* Flux peaks around 250Mi of memory and 100m CPU cores when syncing the cluster with git
* Flagger peaks around 30Mi of memory and 50m CPU cores when running 100 canary releases in-parallel

![result](https://raw.githubusercontent.com/stefanprodan/gitops-benchmark/docs/gitops-benchmark-100-helm-releases.png)
