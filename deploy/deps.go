package deploy

// Static imports for Cue definitions

import (
	_ "k8s.io/api/apps/v1"
	_ "k8s.io/api/core/v1"
	_ "k8s.io/api/rbac/v1"
	_ "k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1beta1"
)
