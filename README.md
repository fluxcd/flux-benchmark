# gitops-benchmark

Flux release candidates testing and benchmark.

## Prerequisites

Start by cloning the repository locally:

```shell
git clone https://github.com/stefanprodan/gitops-benchmark.git
cd gitops-benchmark
```

Install Kubernetes kind, flux, timoni and other CLI tools with Homebrew:

```shell
make tools
```

The complete list of tools can be found in the `Brewfile`.

## Cluster Setup

Create a Kind cluster and a Docker registry:

```shell
make up
```

The Docker registry is exposed on the local machine on `localhost:5555`
and inside the cluster on `flux-registry:5000`. 

The Kubernetes cluster is made out of 3 nodes:
- flux-control-plane (Kubernetes API & etcd)
- flux-worker (Flux controllers)
- flux-worker1 (Prometheus, Grafana, kube-state-metrics, metrics-server)

## Flux Setup

Install Flux on a dedicated node with:

```shell
make flux-install
```

## Monitoring Setup

Install the Flux monitoring stack with:

```shell
timoni bundle apply -f timoni/bundles/flux-monitoring.cue --timeout 10m
```

To access Grafana, start port forward in a separate shell:

```shell
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana  3000:80
```

Navigate to `http://localhost:3000` in your browser and login with user `admin` and password `flux`.

## Benchmark Setup

Push the Timoni modules to the local registry with:

```shell
make timoni-push
```

Install HRs with the podinfo deployment scaled to zero:

```shell
HRS=100 timoni bundle apply -f timoni/bundles/flux-benchmark.cue --runtime-from-env --timeout=10m
```

Upgrade the HRs with:

```shell
HRS=100 MCPU=2 timoni bundle apply -f timoni/bundles/flux-benchmark.cue --runtime-from-env --timeout=10m
```

### Results

Specs:
- MacBook Pro M1 Max
- Docker Desktop for Mac (10 CPU / 24GB)
- Kubernetes Kind (v1.28.0 / 3 nodes)
- Flux source-controller (1CPU / 1Gi)
- Flux helm-controller (2CPU / 1Gi)
- Helm repository (oci://ghcr.io/stefanprodan/charts/podinfo)
- Chart contents (Deployment, Service Account, Service, Ingress)

| Objects | Type        | Flux component    | Concurrency | Total Duration | Max Memory |
|---------|-------------|-------------------|-------------|----------------|------------|
| 100     | HelmChart   | source-controller | 4           | 35s            | 40Mi       |
| 100     | HelmRelease | helm-controller   | 4           | 42s            | 140Mi      |
| 500     | HelmChart   | source-controller | 10          | 1m5s           | 68Mi       |
| 500     | HelmRelease | helm-controller   | 10          | 1m58s          | 350Mi      |
| 1000    | HelmChart   | source-controller | 10          | 1m45s          | 110Mi      |
| 1000    | HelmRelease | helm-controller   | 10          | 4m59s          | 470Mi      |
