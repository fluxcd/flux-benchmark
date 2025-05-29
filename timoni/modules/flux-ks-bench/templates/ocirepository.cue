package templates

import (
	sourcev1 "source.toolkit.fluxcd.io/ocirepository/v1"
)

#OCIRepository: sourcev1.#OCIRepository & {
	_config: #Config
	_index:  int
	metadata: {
		name:      "\(_config.metadata.name)-\(_index)"
		namespace: _config.metadata.namespace
		labels:    _config.metadata.labels
	}
	spec: sourcev1.#OCIRepositorySpec & {
		interval: "\(_config.repository.interval)m"
		insecure: true
		url:      _config.repository.url
		ref: tag: _config.repository.tag
	}
}
