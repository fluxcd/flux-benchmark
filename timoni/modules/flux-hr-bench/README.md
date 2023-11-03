# flux-hr-bench

A [timoni.sh](http://timoni.sh) module for benchmarking Flux Helm Releases.

## Install

To create a benchmark:

```shell
timoni -n benchmark apply podinfo oci://ghcr.io/stefanprodan/modules/flux-hr-bench \
--values ./my-benchmark.cue
```

## Uninstall

To remove the benchmark and delete all its Kubernetes resources:

```shell
timoni -n benchmark delete podinfo
```

## Configuration

| Key                       | Type                  | Default           | Description                                                                                                                                                                    |
|---------------------------|-----------------------|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `releases:`               | `int`                 | `1`               | Number of Flux Helm Releases                                                                                                                                                   |
| `replicas:`               | `int`                 | `2`               | Number of pods per release                                                                                                                                                     |
| `requests: cpu:`          | `int`                 | `1`               | CPU requests in milicores                                                                                                                                                      |
| `role:`                   | `string`              | `namespace-admin` | Restrict the Flux service account to the tenant's namespace using a role binding to `admin`. Can be set to `cluster-admin` for granting full read-write access to the cluster. |
| `fluxServiceAccountName:` | `string`              | `flux`            | Service account to impersonate                                                                                                                                                 |
| `metadata: labels:`       | `{[ string]: string}` | `{}`              | Custom labels                                                                                                                                                                  |
| `metadata: annotations:`  | `{[ string]: string}` | `{}`              | Custom annotations                                                                                                                                                             |
