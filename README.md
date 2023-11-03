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

## Flux Setup

Install Flux (without bootstrap) with:

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

Install HRs with (podinfo deployment is scaled to zero):

```shell
HRS=100 timoni bundle apply -f timoni/bundles/flux-benchmark.cue --runtime-from-env --timeout=5m
```

Upgrade the HRs with:


```shell
HRS=100 MCPU=2 timoni bundle apply -f timoni/bundles/flux-benchmark.cue --runtime-from-env --timeout=5m
```

Bump the HRS number up if you feel courageous.
