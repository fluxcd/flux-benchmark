package templates

import (
	"list"

	timoniv1 "timoni.sh/core/v1alpha1"
)

// Config defines the schema and defaults for the Instance values.
#Config: {
	// Runtime version info
	moduleVersion!: string
	kubeVersion!:   string

	// Metadata (common to all resources)
	metadata: timoniv1.#Metadata & {#Version: moduleVersion}
	metadata: labels: "toolkit.fluxcd.io/tenant": metadata.name

	fluxServiceAccount: string | *"flux"

	role: "namespace-admin" | "cluster-admin" | *"namespace-admin"

	repository: {
		url:      string | *"oci://flux-registry:5000/manifests/podinfo"
		path:     string | *"/"
		tag:      *"latest" | string
		interval: *60 | int
	}

	sync: {
		prune:   *true | bool
		wait:    *true | bool
		timeout: *1 | int
	}

	syncs: int | *1
	pods:  int | *1
	mcpu:  int | *1
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		namespace:      #Namespace & {_config:      config}
		serviceAccount: #ServiceAccount & {_config: config}
		roleBinding:    #NamespaceAdmin & {_config: config}
	}

	if config.role == "cluster-admin" {
		objects: clusterRoleBinding: #ClusterAdmin & {_config: config}
	}

	for i in list.Range(0, config.syncs, 1) {
		objects: "oci-\(i)": #OCIRepository & {
			_config: config
			_index:  i
		}

		objects: "ks-\(i)": #Kustomization & {
			_config: config
			_index:  i
		}
	}
}
