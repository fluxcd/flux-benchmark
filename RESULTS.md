# MTTP Benchmark Results

The Mean Time To Production (MTTP) benchmark measures the time it takes for
Flux to deploy application changes into production. We measure the time spent
on fetching app packages from the registry (Flux OCI artifacts and Helm charts)
and the time spent reconciling app definitions on the Kubernetes cluster.

For this benchmark we assume 100, 500 and 1000 app packages being pushed to the
registry at the same time.

**Specs**

- GitHub hosted-runner (ubuntu-latest-16-cores)
- Kubernetes Kind (3 nodes)
- Flux source-controller (1CPU / 1Gi / concurrency 10)
- Flux kustomize-controller (2CPU / 1Gi / concurrency 20)
- Flux helm-controller (2CPU / 1Gi / concurrency 10)
- Helm repository (oci://ghcr.io/stefanprodan/charts/podinfo)
- App manifests (Deployment scaled to zero, Service Account, Service, Ingress)


## Flux v2.6.0

| Objects | Type          | Flux component       | Duration | Max Memory |
|---------|---------------|----------------------|----------|------------|
| 100     | OCIRepository | source-controller    | 24s      | 38Mi       |
| 100     | Kustomization | kustomize-controller | 28s      | 32Mi       |
| 100     | HelmChart     | source-controller    | 24s      | 40Mi       |
| 100     | HelmRelease   | helm-controller      | 27s      | 190Mi      |
| 500     | OCIRepository | source-controller    | 43s      | 65Mi       |
| 500     | Kustomization | kustomize-controller | 2m2s     | 122Mi      |
| 500     | HelmChart     | source-controller    | 48s      | 68Mi       |
| 500     | HelmRelease   | helm-controller      | 2m10s    | 240Mi      |
| 1000    | OCIRepository | source-controller    | 1m25s    | 67Mi       |
| 1000    | Kustomization | kustomize-controller | 4m16s    | 175Mi      |
| 1000    | HelmChart     | source-controller    | 1m20s    | 110Mi      |
| 1000    | HelmRelease   | helm-controller      | 5m12s    | 350Mi      |

### Observations

Compared to Flux v2.5 & Kubernetes 1.30, Flux v2.6 on Kubernetes 1.33
has a major performance improvement in the reconciliation speed of HelmRelease
objects, especially when the cluster has hundreds of CRDs registered.

## Flux v2.5.0

| Objects | Type          | Flux component       | Duration | Max Memory |
|---------|---------------|----------------------|----------|------------|
| 100     | OCIRepository | source-controller    | 24s      | 38Mi       |
| 100     | Kustomization | kustomize-controller | 28s      | 32Mi       |
| 100     | HelmChart     | source-controller    | 24s      | 40Mi       |
| 100     | HelmRelease   | helm-controller      | 27s      | 190Mi      |
| 500     | OCIRepository | source-controller    | 43s      | 65Mi       |
| 500     | Kustomization | kustomize-controller | 2m2s     | 122Mi      |
| 500     | HelmChart     | source-controller    | 48s      | 68Mi       |
| 500     | HelmRelease   | helm-controller      | 2m45s    | 240Mi      |
| 1000    | OCIRepository | source-controller    | 1m25s    | 67Mi       |
| 1000    | Kustomization | kustomize-controller | 4m16s    | 175Mi      |
| 1000    | HelmChart     | source-controller    | 1m20s    | 110Mi      |
| 1000    | HelmRelease   | helm-controller      | 8m12s    | 400Mi      |

### Observations

Compared to Flux v2.4, there are no performance differences in Flux v2.5.

## Flux v2.4.0

| Objects | Type          | Flux component       | Duration | Max Memory |
|---------|---------------|----------------------|----------|------------|
| 100     | OCIRepository | source-controller    | 25s      | 38Mi       |
| 100     | Kustomization | kustomize-controller | 27s      | 32Mi       |
| 100     | HelmChart     | source-controller    | 25s      | 40Mi       |
| 100     | HelmRelease   | helm-controller      | 28s      | 190Mi      |
| 500     | OCIRepository | source-controller    | 45s      | 65Mi       |
| 500     | Kustomization | kustomize-controller | 2m4s     | 122Mi      |
| 500     | HelmChart     | source-controller    | 45s      | 68Mi       |
| 500     | HelmRelease   | helm-controller      | 2m44s    | 240Mi      |
| 1000    | OCIRepository | source-controller    | 1m30s    | 67Mi       |
| 1000    | Kustomization | kustomize-controller | 4m15s    | 175Mi      |
| 1000    | HelmChart     | source-controller    | 1m30s    | 110Mi      |
| 1000    | HelmRelease   | helm-controller      | 8m1s     | 400Mi      |

### Observations

Compared to Flux v2.3, the memory consumption of kustomize-controller
and helm-controller has slight improved when reconciling over 500 apps.

## Flux v2.3.0

| Objects | Type          | Flux component       | Duration | Max Memory |
|---------|---------------|----------------------|----------|------------|
| 100     | OCIRepository | source-controller    | 25s      | 38Mi       |
| 100     | Kustomization | kustomize-controller | 27s      | 32Mi       |
| 100     | HelmChart     | source-controller    | 25s      | 40Mi       |
| 100     | HelmRelease   | helm-controller      | 28s      | 190Mi      |
| 500     | OCIRepository | source-controller    | 45s      | 65Mi       |
| 500     | Kustomization | kustomize-controller | 2m4s     | 134Mi      |
| 500     | HelmChart     | source-controller    | 45s      | 68Mi       |
| 500     | HelmRelease   | helm-controller      | 2m45s    | 250Mi      |
| 1000    | OCIRepository | source-controller    | 1m30s    | 67Mi       |
| 1000    | Kustomization | kustomize-controller | 4m15s    | 190Mi      |
| 1000    | HelmChart     | source-controller    | 1m30s    | 110Mi      |
| 1000    | HelmRelease   | helm-controller      | 8m1s     | 490Mi      |

### Observations

Compared to Flux v2.2, in this version the memory consumption of the helm-controller
has improved a lot, especially when the cluster has hundreds of CRDs registered.
In Flux v2.2, helm-controller on Kubernetes v1.28 is running out of memory
with 100 CRDs registered, while in Flux v2.3 on Kubernetes v1.29 it can handle
500+ CRDs without issues. Given these results, it is recommended
to upgrade the Kubernetes control plane to v1.29 and Flux to v2.3.

## Flux v2.2.0

| Objects | Type          | Flux component       | Duration | Max Memory |
|---------|---------------|----------------------|----------|------------|
| 100     | OCIRepository | source-controller    | 25s      | 38Mi       |
| 100     | Kustomization | kustomize-controller | 27s      | 32Mi       |
| 100     | HelmChart     | source-controller    | 25s      | 40Mi       |
| 100     | HelmRelease   | helm-controller      | 31s      | 140Mi      |
| 500     | OCIRepository | source-controller    | 45s      | 65Mi       |
| 500     | Kustomization | kustomize-controller | 2m2s     | 72Mi       |
| 500     | HelmChart     | source-controller    | 45s      | 68Mi       |
| 500     | HelmRelease   | helm-controller      | 2m55s    | 350Mi      |
| 1000    | OCIRepository | source-controller    | 1m30s    | 67Mi       |
| 1000    | Kustomization | kustomize-controller | 4m15s    | 112Mi      |
| 1000    | HelmChart     | source-controller    | 1m30s    | 110Mi      |
| 1000    | HelmRelease   | helm-controller      | 8m2s     | 620Mi      |

### Observations

Increasing kustomize-controller's concurrency above 10 does yield better
results, but the `/tmp` directory must be in tmpfs to prevent the Kustomize
build from disk thrashing. Documentation on this can be found here:
https://fluxcd.io/flux/installation/configuration/vertical-scaling/#enable-in-memory-kustomize-builds

Increasing helm-controller's concurrency above 10 does not yield better
results due to Helm SDK overloading the Kubernetes OpenAPI endpoint.
Higher concurrency probably requires an HA Kubernetes control plane with
multiple API replicas.
