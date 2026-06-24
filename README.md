# flux-benchmark

[![benchmark](https://github.com/fluxcd/flux-benchmark/actions/workflows/test.yaml/badge.svg)](https://github.com/fluxcd/flux-benchmark/actions/workflows/test.yaml)

**Mean Time To Production** benchmarks
for [Flux](https://fluxcd.io) release candidates,
made with [Timoni](https://github.com/stefanprodan/timoni).

The benchmark results can be found in [RESULTS.md](RESULTS.md).

## Prerequisites

Start by cloning the repository locally:

```shell
git clone https://github.com/stefanprodan/flux-benchmark.git
cd flux-benchmark
```

Install Kubernetes kind, flux, timoni, crane and other CLI tools with Homebrew:

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
make flux-up
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

Run the benchmark for OCI artifact pull and Flux Kustomization install:

```shell
KS=100 timoni bundle apply -f timoni/bundles/flux-benchmark.cue --runtime-from-env --timeout=10m
```

Run the benchmark for Flux Kustomization upgrade:

```shell
KS=100 MCPU=2 timoni bundle apply -f timoni/bundles/flux-benchmark.cue --runtime-from-env --timeout=10m
```

### Flux HelmRelease Benchmark

Run the benchmark for Helm chart pull and Flux HelmRelease install:

```shell
HR=100 timoni bundle apply -f timoni/bundles/flux-benchmark.cue --runtime-from-env --timeout=10m
```

Run the benchmark for Flux HelmRelease upgrade:

```shell
HR=100 MCPU=2 timoni bundle apply -f timoni/bundles/flux-benchmark.cue --runtime-from-env --timeout=10m
```

### Teardown

Remove all Flux resources and the benchmark namespaces with:

```shell
timoni bundle delete flux-benchmark
```
