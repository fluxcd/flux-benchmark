# flux-benchmark

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

### Flux Kustomization Benchmark

Run benchmark for OCI artifact pull and Flux Kustomization install:

```shell
KS=100 timoni bundle apply -f timoni/bundles/flux-kustomize-benchmark.cue --runtime-from-env --timeout=10m
```

Run benchmark for Flux Kustomization upgrade:

```shell
KS=100 MCPU=2 timoni bundle apply -f timoni/bundles/flux-kustomize-benchmark.cue --runtime-from-env --timeout=10m
```

Teardown:

```shell
timoni bundle delete flux-kustomize-benchmark
```

### Flux HelmRelease Benchmark

Run benchmark for Helm chart pull and Helm Release install:

```shell
HRS=100 timoni bundle apply -f timoni/bundles/flux-helm-benchmark.cue --runtime-from-env --timeout=10m
```

Run benchmark for Helm Release upgrade:

```shell
HRS=100 MCPU=2 timoni bundle apply -f timoni/bundles/flux-helm-benchmark.cue --runtime-from-env --timeout=10m
```

Teardown:

```shell
timoni bundle delete flux-helm-benchmark
```

## Benchmark Results (Flux v2.2 RC)

| Objects | Type          | Flux component       | Concurrency | Total Duration | Max Memory |
|---------|---------------|----------------------|-------------|----------------|------------|
| 100     | OCIRepository | source-controller    | 4           | 35s            | 38Mi       |
| 100     | Kustomization | kustomize-controller | 4           | 38s            | 32Mi       |
| 100     | HelmChart     | source-controller    | 4           | 35s            | 40Mi       |
| 100     | HelmRelease   | helm-controller      | 4           | 42s            | 140Mi      |
| 500     | OCIRepository | source-controller    | 10          | 45s            | 65Mi       |
| 500     | Kustomization | kustomize-controller | 10          | 1m50s          | 72Mi       |
| 500     | HelmChart     | source-controller    | 10          | 1m5s           | 68Mi       |
| 500     | HelmRelease   | helm-controller      | 10          | 1m58s          | 350Mi      |
| 1000    | OCIRepository | source-controller    | 10          | 1m30s          | 67Mi       |
| 1000    | Kustomization | kustomize-controller | 20          | 3m58s          | 112Mi      |
| 1000    | HelmChart     | source-controller    | 10          | 1m45s          | 110Mi      |
| 1000    | HelmRelease   | helm-controller      | 10          | 5m10s          | 620Mi      |

### Specs

- MacBook Pro M1 Max
- Docker Desktop for Mac (10 CPU / 24GB)
- Kubernetes Kind (v1.28.0 / 3 nodes)
- Flux source-controller (1CPU / 1Gi)
- Flux kustomize-controller (1CPU / 1Gi)
- Flux helm-controller (2CPU / 1Gi)
- Helm repository (oci://ghcr.io/stefanprodan/charts/podinfo)
- App manifests (Deployment scaled to zero, Service Account, Service, Ingress)
