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
