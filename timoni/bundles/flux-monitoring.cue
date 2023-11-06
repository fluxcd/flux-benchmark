bundle: {
	apiVersion: "v1alpha1"
	name:       "flux-monitoring"
	instances: {
		"monitoring-team": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-tenant"
			namespace: "monitoring"
			values: role: "cluster-admin"
		}
		"monitoring-controllers": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-git-sync"
			namespace: "monitoring"
			values: {
				git: {
					url:  "https://github.com/fluxcd/flux2-monitoring-example"
					ref:  "refs/heads/main"
					path: "monitoring/controllers/kube-prometheus-stack"
				}
				sync: serviceAccountName: "flux"
			}
		}
		"monitoring-configs": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-git-sync"
			namespace: "monitoring"
			values: {
				git: {
					url:  "https://github.com/fluxcd/flux2-monitoring-example"
					ref:  "refs/heads/main"
					path: "monitoring/configs"
				}
				sync: serviceAccountName: "flux"
			}
		}
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
