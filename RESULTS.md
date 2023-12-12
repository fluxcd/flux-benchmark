# MTTP Benchmark Results

The Mean Time To Production (MTTP) benchmark measures the time it takes for
Flux to deploy application changes into production. We measure the time spent
on fetching app packages from the registry (Flux OCI artifacts and Helm charts)
and the time spent reconciling app definitions on the Kubernetes cluster.

For this benchmark we assume 100, 500 and 1000 app packages being pushed to the
registry at the same time.

**Specs**

- GitHub hosted-runner (ubuntu-latest-16-cores)
- Kubernetes Kind (v1.28.0 / 3 nodes)
- Flux source-controller (1CPU / 1Gi / concurrency 10)
- Flux kustomize-controller (1CPU / 1Gi / concurrency 20)
- Flux helm-controller (2CPU / 1Gi / concurrency 10)
- Helm repository (oci://ghcr.io/stefanprodan/charts/podinfo)
- App manifests (Deployment scaled to zero, Service Account, Service, Ingress)

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
build from disk thrashing.

Increasing helm-controller's concurrency above 10 does not yield better
results due to Helm SDK overloading the Kubernetes OpenAPI endpoint.
Higher concurrency probably requires an HA Kubernetes control plane with
multiple API replicas.

