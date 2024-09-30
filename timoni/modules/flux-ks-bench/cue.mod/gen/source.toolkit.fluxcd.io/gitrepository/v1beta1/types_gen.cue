// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/fluxcd/source-controller/releases/download/v1.4.1/source-controller.crds.yaml

package v1beta1

import "strings"

// GitRepository is the Schema for the gitrepositories API
#GitRepository: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "source.toolkit.fluxcd.io/v1beta1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "GitRepository"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace!: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}

	// GitRepositorySpec defines the desired state of a Git
	// repository.
	spec!: #GitRepositorySpec
}

// GitRepositorySpec defines the desired state of a Git
// repository.
#GitRepositorySpec: {
	accessFrom?: {
		// NamespaceSelectors is the list of namespace selectors to which
		// this ACL applies.
		// Items in this list are evaluated using a logical OR operation.
		namespaceSelectors: [...{
			// MatchLabels is a map of {key,value} pairs. A single {key,value}
			// in the matchLabels
			// map is equivalent to an element of matchExpressions, whose key
			// field is "key", the
			// operator is "In", and the values array contains only "value".
			// The requirements are ANDed.
			matchLabels?: {
				[string]: string
			}
		}]
	}

	// Determines which git client library to use.
	// Defaults to go-git, valid values are ('go-git', 'libgit2').
	gitImplementation?: "go-git" | "libgit2" | *"go-git"

	// Ignore overrides the set of excluded patterns in the
	// .sourceignore format
	// (which is the same as .gitignore). If not provided, a default
	// will be used,
	// consult the documentation for your version to find out what
	// those are.
	ignore?: string

	// Extra git repositories to map into the repository
	include?: [...{
		// The path to copy contents from, defaults to the root directory.
		fromPath?: string
		repository: {
			// Name of the referent.
			name: string
		}

		// The path to copy contents to, defaults to the name of the
		// source ref.
		toPath?: string
	}]

	// The interval at which to check for repository updates.
	interval: string

	// When enabled, after the clone is created, initializes all
	// submodules within,
	// using their default settings.
	// This option is available only when using the 'go-git'
	// GitImplementation.
	recurseSubmodules?: bool

	// The Git reference to checkout and monitor for changes, defaults
	// to
	// master branch.
	ref?: {
		// The Git branch to checkout, defaults to master.
		branch?: string

		// The Git commit SHA to checkout, if specified Tag filters will
		// be ignored.
		commit?: string

		// The Git tag semver expression, takes precedence over Tag.
		semver?: string

		// The Git tag to checkout, takes precedence over Branch.
		tag?: string
	}
	secretRef?: {
		// Name of the referent.
		name: string
	}

	// This flag tells the controller to suspend the reconciliation of
	// this source.
	suspend?: bool

	// The timeout for remote Git operations like cloning, defaults to
	// 60s.
	timeout?: string | *"60s"

	// The repository URL, can be a HTTP/S or SSH address.
	url: =~"^(http|https|ssh)://.*$"

	// Verify OpenPGP signature for the Git commit HEAD points to.
	verify?: {
		// Mode describes what git object should be verified, currently
		// ('head').
		mode: "head"
		secretRef?: {
			// Name of the referent.
			name: string
		}
	}
}
