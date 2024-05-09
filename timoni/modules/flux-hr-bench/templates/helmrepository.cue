package templates

import (
	fluxv1 "source.toolkit.fluxcd.io/helmrepository/v1"
)

#HelmRepository: fluxv1.#HelmRepository & {
	_config:  #Config
	metadata: _config.metadata
	spec:     fluxv1.#HelmRepositorySpec & {
		interval: "12h"
		timeout:  "2m"
		insecure: true

		url:  _config.repository.url
		type: _config.repository.type
	}
}
