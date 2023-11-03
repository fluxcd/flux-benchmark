bundle: {
	apiVersion: "v1alpha1"
	name:       "flux-benchmark"
	instances: {
		"podinfo": {
			module: url: "oci://localhost:5555/modules/flux-hr-bench"
			namespace: "benchmark"
			values: {
				chart: {
					name:     "podinfo"
					version:  "6.5.3"
					interval: 60
				}
				releases: 100 @timoni(runtime:number:HRS)
				replicas: 0
				requests: {
					cpu: 1 @timoni(runtime:number:MCPU)
				}
			}
		}
	}
}
