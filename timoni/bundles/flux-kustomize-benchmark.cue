bundle: {
	apiVersion: "v1alpha1"
	name:       "flux-kustomize-benchmark"
	instances: {
		"podinfo": {
			module: url: "oci://localhost:5555/modules/flux-ks-bench"
			namespace: "kustomize-benchmark"
			values: {
				syncs: 1 @timoni(runtime:number:KS)
				mcpu:  1   @timoni(runtime:number:MCPU)
			}
		}
	}
}
