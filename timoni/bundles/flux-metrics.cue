bundle: {
	apiVersion: "v1alpha1"
	name:       "flux-monitoring"
	instances: {
		"metrics-server": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "monitoring"
			values: {
				repository: url: "https://kubernetes-sigs.github.io/metrics-server"
				chart: name:     "metrics-server"
				helmValues: {
					args: ["--kubelet-insecure-tls"]
				}
			}
		}
	}
}
