package k8s

import (
	core_v1 "k8s.io/api/core/v1"
	apps_v1 "k8s.io/api/apps/v1"
	rbac_v1 "k8s.io/api/rbac/v1"
	apiext_v1beta1 "k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1beta1"
)

k8s: close({
	// TODO(leo): type CRDs
	kafkas: [Name=_]: {
		apiVersion: "kafka.strimzi.io/v1beta1"
		kind:       "Kafka"
		metadata: name: Name
	}
	kafkatopics: [Name=_]: {
		apiVersion: "kafka.strimzi.io/v1beta1"
		kind:       "KafkaTopic"
		metadata: name: Name
	}
	clickhouseinstallations: [Name=_]: {
		apiVersion: "clickhouse.altinity.com/v1"
		kind:       "ClickHouseInstallation"
		metadata: name: Name
	}
	ingressroutes: [Name=_]: {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "IngressRoute"
		metadata: name: Name
	}
	ingressrouteudps: [Name=_]: {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "IngressRouteUDP"
		metadata: name: Name
	}
	crds: [Name=_]: apiext_v1beta1.CustomResourceDefinition & {
		apiVersion: "apiextensions.k8s.io/v1beta1"
		kind:       "CustomResourceDefinition"
		metadata: name: Name
	}
	serviceaccounts: [Name=_]: core_v1.ServiceAccount & {
		apiVersion: "v1"
		kind:       "ServiceAccount"
		metadata: name: Name
	}
	secrets: [Name=_]: core_v1.Secret & {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: name: Name
	}
	configmaps: [Name=_]: core_v1.ConfigMap & {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: Name
	}
	pvcs: [Name=_]: core_v1.PersistentVolumeClaim & {
		apiVersion: "v1"
		kind:       "PersistentVolumeClaim"
		metadata: name: Name
		spec: {
			// Binds to local volume
			accessModes: ["ReadWriteOnce"]
			resources: requests: storage: "1Gi"
		}
	}
	services: [Name=_]: core_v1.Service & {
		apiVersion: "v1"
		kind:       "Service"
		metadata: name: Name
		metadata: labels: name: Name
	}
	statefulsets: [Name=_]: apps_v1.StatefulSet & {
		apiVersion: "apps/v1"
		kind:       "StatefulSet"
		metadata: name: Name
	}
	deployments: [Name=_]: apps_v1.Deployment & {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: name: Name
	}
	clusterrolebindings: [Name=_]: rbac_v1.ClusterRoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: Name
	}
	clusterroles: [Name=_]: rbac_v1.ClusterRole & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: name: Name
	}
	rolebindings: [Name=_]: rbac_v1.RoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "RoleBinding"
		metadata: name: Name
	}
})
