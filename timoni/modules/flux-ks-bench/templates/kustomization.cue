package templates

import (
	ksv1 "kustomize.toolkit.fluxcd.io/kustomization/v1"
	sourcev1 "source.toolkit.fluxcd.io/ocirepository/v1beta2"
)

#Kustomization: ksv1.#Kustomization & {
	_config: #Config
	_index:  int
	metadata: {
		name:      "\(_config.metadata.name)-\(_index)"
		namespace: _config.metadata.namespace
		labels:    _config.metadata.labels
	}
	spec: ksv1.#KustomizationSpec & {
		sourceRef: {
			kind: sourcev1.#OCIRepository.kind
			name: "\(_config.metadata.name)-\(_index)"
		}
		interval:           "5m"
		retryInterval:      "2m"
		path:               _config.repository.path
		prune:              _config.sync.prune
		wait:               _config.sync.wait
		timeout:            "\(_config.sync.timeout)m"
		serviceAccountName: _config.fluxServiceAccount
		targetNamespace:    _config.metadata.namespace

		postBuild: substitute: {
			"INDEX": "\(_index)app"
			"PODS":  "\(_config.pods)"
			"MCPU":  "\(_config.mcpu)m"
		}

	}
}
