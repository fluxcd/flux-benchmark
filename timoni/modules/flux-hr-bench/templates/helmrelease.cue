package templates

import (
	fluxv2 "helm.toolkit.fluxcd.io/helmrelease/v2"
)

#HelmRelease: fluxv2.#HelmRelease & {
	_config: #Config
	_index:  int
	metadata: {
		name:      "\(_config.metadata.name)-\(_index)"
		namespace: _config.metadata.namespace
		labels:    _config.metadata.labels
	}
	spec: fluxv2.#HelmReleaseSpec & {
		releaseName:        "\(_config.metadata.name)-\(_index)"
		serviceAccountName: _config.fluxServiceAccount
		targetNamespace:    _config.metadata.namespace
		storageNamespace:   _config.metadata.namespace
		interval:           "\(_config.chart.interval)m"
		chart: {
			spec: {
				chart:   "\(_config.chart.name)"
				version: "\(_config.chart.version)"
				sourceRef: {
					kind: "HelmRepository"
					name: "\(_config.metadata.name)"
				}
				interval: "\(10*_config.chart.interval)m"
			}
		}
		driftDetection: {
			mode: _config.driftDetection
		}
		install: crds: "Create"
		upgrade: crds: "CreateReplace"
		if _config.rollback {
			upgrade: remediation: retries: 3
		}
		if _config.pods > 0 {
			test: enable: _config.runTests
		}
		values: {
			replicaCount: _config.pods
			if _config.pods > 0 {
				hpa: {
					enabled:     true
					maxReplicas: _config.pods
					cpu:         99
				}
			}
			serviceAccount: enabled: true
			ingress: {
				enabled:   true
				className: "nginx"
			}
			resources: requests: {
				cpu:    "\(_config.mcpu)m"
				memory: "16Mi"
			}
			faults: testFail: _config.failTests
		}
	}
}
