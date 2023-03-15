package k8s

import (
	core_v1 "k8s.io/api/core/v1"
	apps_v1 "k8s.io/api/apps/v1"
	rbac_v1 "k8s.io/api/rbac/v1"
	apiextensions_v1 "k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1"

	traefikBase "github.com/monogon-dev/NetMeta/deploy/k8s-base/traefik:k8s"
	traefik "github.com/monogon-dev/NetMeta/deploy/single-node/k8s/traefik"

	clickhouseOperator "github.com/monogon-dev/NetMeta/deploy/k8s-base/clickhouse-operator:k8s"
	clickhouse "github.com/monogon-dev/NetMeta/deploy/single-node/k8s/clickhouse"

	strimziKafkaOperator "github.com/monogon-dev/NetMeta/deploy/k8s-base/strimzi-kafka-operator:k8s"
	kafka "github.com/monogon-dev/NetMeta/deploy/single-node/k8s/kafka"

	// Dashboards
	grafana_dashboards "github.com/monogon-dev/NetMeta/deploy/dashboards"

	grafana "github.com/monogon-dev/NetMeta/deploy/single-node/k8s/grafana"

	schema "github.com/monogon-dev/NetMeta/deploy/single-node/schema"
	reconciler "github.com/monogon-dev/NetMeta/deploy/single-node/k8s/reconciler"

	risinfo "github.com/monogon-dev/NetMeta/deploy/single-node/k8s/risinfo"

	goflow "github.com/monogon-dev/NetMeta/deploy/single-node/k8s/goflow"

	portmirror "github.com/monogon-dev/NetMeta/deploy/single-node/k8s/portmirror"
)

netmeta: images: #NetMetaImages
netmeta: config: #NetMetaConfig
netmeta: dashboards: {
	_dashboards: (grafana_dashboards & {
		#Config: {
			interval:      netmeta.config.dashboardDisplay.minInterval
			maxPacketSize: netmeta.config.dashboardDisplay.maxPacketSize
			fastNetMon:    netmeta.config.fastNetMon
		}
	})
	for k, v in _dashboards.dashboards {
		"\(k)": v
	}
}

_schema: (schema & {
	#Config: {
		fastNetMon: netmeta.config.fastNetMon
		sampler:    netmeta.config.sampler
	}
})

k8s_list: [
	traefikBase,
	(traefik & {
		#Config: {
			ports: http:       netmeta.config.ports.http
			ports: https:      netmeta.config.ports.https
			ports: clickhouse: netmeta.config.ports.clickhouse
			letsencryptMode:         netmeta.config.letsencryptMode
			letsencryptAccountMail:  netmeta.config.letsencryptAccountMail
			enableClickhouseIngress: netmeta.config.enableClickhouseIngress
		}
	}),

	clickhouseOperator,
	(clickhouse & {
		#Config: {
			clickhouseAdminPassword:    netmeta.config.clickhouseAdminPassword
			clickhouseReadonlyPassword: netmeta.config.clickhouseReadonlyPassword
			enableClickhouseIngress:    netmeta.config.enableClickhouseIngress
			sampler:                    netmeta.config.sampler
		}
	}),

	strimziKafkaOperator,
	(kafka & {
		#Config: {
			goflowTopicRetention:        netmeta.config.goflowTopicRetention
			enableExternalKafkaListener: netmeta.config.enableExternalKafkaListener
			advertisedKafkaHost:         netmeta.config.advertisedKafkaHost
			fastNetMon:                  netmeta.config.fastNetMon
		}
	}),

	(risinfo & {
		#Config: {
			image:  netmeta.images.risinfo.image
			digest: netmeta.images.risinfo.digest
		}
	}),

	(grafana & {
		#Config: {
			image:                       netmeta.images.grafana.image
			digest:                      netmeta.images.grafana.digest
			publicHostname:              netmeta.config.publicHostname
			grafanaInitialAdminPassword: netmeta.config.grafanaInitialAdminPassword
			grafanaBasicAuth:            netmeta.config.grafanaBasicAuth
			sessionSecret:               netmeta.config.sessionSecret
			grafanaDefaultRole:          netmeta.config.grafanaDefaultRole
			clickhouseReadonlyPassword:  netmeta.config.clickhouseReadonlyPassword
			fastNetMon:                  netmeta.config.fastNetMon
			grafanaGoogleAuth:           netmeta.config.grafanaGoogleAuth
			dashboards:                  netmeta.dashboards
		}
	}),

	(reconciler & {
		#Config: {
			image:        netmeta.images.reconciler.image
			digest:       netmeta.images.reconciler.digest
			databaseHost: "clickhouse-netmeta:9000"
			databaseUser: "admin"
			databasePass: netmeta.config.clickhouseAdminPassword
			config: {
				database: "default"
				functions: [ for _, v in _schema.function {v}]
				materialized_views: [ for _, v in _schema.view {v}]
				source_tables: [ for _, v in _schema.table {v}]
			}
			files: _schema.file
		}
	}),

	if netmeta.config.deployGoflow {
		(goflow & {
			#Config: {
				image:  netmeta.images.goflow.image
				digest: netmeta.images.goflow.digest
				ports: {
					netflow:       netmeta.config.ports.netflow
					netflowLegacy: netmeta.config.ports.netflowLegacy
					sflow:         netmeta.config.ports.sflow
				}
			}
		})
	},

	if netmeta.config.portMirror != _|_ {
		(portmirror & {
			#Config: {
				image:          netmeta.images.portmirror.image
				digest:         netmeta.images.portmirror.digest
				interfaces:     netmeta.config.portMirror.interfaces
				sampleRate:     netmeta.config.portMirror.sampleRate
				samplerAddress: netmeta.config.portMirror.samplerAddress
			}
		})
	},
]

// We transfer all entries in the k8s_list into the k8s struct with a loop,
// because when we directly enter them into the struct, the different #Config
// instances collide
k8s: {
	for _, e in k8s_list for k, v in e {
		"\(k)": v
	}
}

k8s: [KIND=string]: [NAME=string]: {
	kind: KIND
	metadata: name:      NAME
	metadata: namespace: netmeta.config.namespace
}

k8s: close({
	Deployment: [string]:                 apps_v1.#Deployment & {apiVersion:     "apps/v1"}
	StatefulSet: [string]:                apps_v1.#StatefulSet & {apiVersion:    "apps/v1"}
	Service: [string]:                    core_v1.#Service & {apiVersion:        "v1"}
	ConfigMap: [string]:                  core_v1.#ConfigMap & {apiVersion:      "v1"}
	Secret: [string]:                     core_v1.#Secret & {apiVersion:         "v1"}
	ServiceAccount: [string]:             core_v1.#ServiceAccount & {apiVersion: "v1"}
	PersistentVolumeClaim: [NANE=string]: core_v1.#PersistentVolumeClaim & {
		apiVersion: "v1"
		spec: accessModes: ["ReadWriteOnce"]
		// Its required to submit a storage request. Since we only have caches (and want to be compatible to the default), we set a default of 1Gi
		spec: resources: requests: storage: *"1Gi" | string
	}
	Role: [string]:        rbac_v1.#Role & {apiVersion:        "rbac.authorization.k8s.io/v1"}
	RoleBinding: [string]: rbac_v1.#RoleBinding & {apiVersion: "rbac.authorization.k8s.io/v1"}

	Namespace: [string]:                core_v1.#Namespace & {apiVersion:                         "v1"}
	ClusterRole: [string]:              rbac_v1.#ClusterRole & {apiVersion:                       "rbac.authorization.k8s.io/v1"}
	ClusterRoleBinding: [string]:       rbac_v1.#ClusterRoleBinding & {apiVersion:                "rbac.authorization.k8s.io/v1"}
	CustomResourceDefinition: [string]: apiextensions_v1.#CustomResourceDefinition & {apiVersion: "apiextensions.k8s.io/v1"}

	//The traefik crds arent compatible with cue get: `builtin package "crypto/tls" undefined`
	TLSOption: [string]: {apiVersion: "traefik.containo.us/v1alpha1", ...}
	IngressRoute: [string]: {apiVersion: "traefik.containo.us/v1alpha1", ...}

	//TODO(fionera): Add Clickhouse CRD
	ClickHouseInstallation: [string]: {apiVersion: "clickhouse.altinity.com/v1", ...}

	//The strimzi crds are not available as go code, so we would have to create them manually
	Kafka: [string]: {apiVersion: "kafka.strimzi.io/v1beta2", ...}
	KafkaTopic: [string]: {apiVersion: "kafka.strimzi.io/v1beta2", ...}
})

all_objects: [ for _, v in k8s for _, x in v {x}]

objects: [ for v in all_objects if v.kind != "CustomResourceDefinition" {v}]

// Prerequisite objects to apply first, in a separate kubectl call.
preObjects: [ for v in all_objects if v.kind == "CustomResourceDefinition" {v}]
