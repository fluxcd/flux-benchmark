bundle: {
	_ks: 0 @timoni(runtime:number:KS)
	_hr: 0 @timoni(runtime:number:HR)

	apiVersion: "v1alpha1"
	name:       "flux-benchmark"
	instances: {
		if _ks > 0 {
			"podinfo-ks": {
				module: url: "oci://localhost:5555/modules/flux-ks-bench"
				namespace: "kustomize-benchmark"
				values: {
					syncs: _ks
					pods:  0 @timoni(runtime:number:PODS)
					mcpu:  1 @timoni(runtime:number:MCPU)
				}
			}
		}
		if _hr > 0 {
			"podinfo-hr": {
				module: url: "oci://localhost:5555/modules/flux-hr-bench"
				namespace: "helm-benchmark"
				values: {
					chart: {
						name:     "podinfo"
						version:  "6.5.3"
						interval: 60
					}
					releases: _hr
					pods:     0 @timoni(runtime:number:PODS)
					mcpu:     1 @timoni(runtime:number:MCPU)
				}
			}
		}
	}
}
