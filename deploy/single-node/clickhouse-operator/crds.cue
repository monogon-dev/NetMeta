package k8s

k8s: crds: {
	"clickhouseinstallations.clickhouse.altinity.com": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: name: "clickhouseinstallations.clickhouse.altinity.com"
		spec: {
			group: "clickhouse.altinity.com"
			scope: "Namespaced"
			names: {
				kind:     "ClickHouseInstallation"
				singular: "clickhouseinstallation"
				plural:   "clickhouseinstallations"
				shortNames: ["chi"]
			}
			versions: [{
				name:    "v1"
				served:  true
				storage: true
				additionalPrinterColumns: [{
					name:        "version"
					type:        "string"
					description: "Operator version"
					priority:    1
					jsonPath:    ".status.version"
				}, {
					name:        "clusters"
					type:        "integer"
					description: "Clusters count"
					priority:    0
					jsonPath:    ".status.clusters"
				}, {
					name:        "shards"
					type:        "integer"
					description: "Shards count"
					priority:    1
					jsonPath:    ".status.shards"
				}, {
					name:        "hosts"
					type:        "integer"
					description: "Hosts count"
					priority:    0
					jsonPath:    ".status.hosts"
				}, {
					name:        "taskID"
					type:        "string"
					description: "TaskID"
					priority:    1
					jsonPath:    ".status.taskID"
				}, {
					name:        "status"
					type:        "string"
					description: "CHI status"
					priority:    0
					jsonPath:    ".status.status"
				}, {
					name:        "updated"
					type:        "integer"
					description: "Updated hosts count"
					priority:    1
					jsonPath:    ".status.updated"
				}, {
					name:        "added"
					type:        "integer"
					description: "Added hosts count"
					priority:    1
					jsonPath:    ".status.added"
				}, {
					name:        "deleted"
					type:        "integer"
					description: "Hosts deleted count"
					priority:    1
					jsonPath:    ".status.deleted"
				}, {
					name:        "delete"
					type:        "integer"
					description: "Hosts to be deleted count"
					priority:    1
					jsonPath:    ".status.delete"
				}, {
					name:        "endpoint"
					type:        "string"
					description: "Client access endpoint"
					priority:    1
					jsonPath:    ".status.endpoint"
				}]
				subresources: status: {}
				schema: openAPIV3Schema: {
					description: "define a set of Kubernetes resources (StatefulSet, PVC, Service, ConfigMap) which describe behavior one or more ClickHouse clusters"
					type:        "object"
					required: ["spec"]
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						status: {
							type:        "object"
							description: "Current ClickHouseInstallation manifest status, contains many fields like a normalized configuration, clickhouse-operator version, current action and all applied action list, current taskID and all applied taskIDs and other"
							properties: {
								version: {
									type:        "string"
									description: "Version"
								}
								clusters: {
									type:        "integer"
									minimum:     0
									description: "Clusters count"
								}
								shards: {
									type:        "integer"
									minimum:     0
									description: "Shards count"
								}
								replicas: {
									type:        "integer"
									minimum:     0
									description: "Replicas count"
								}
								hosts: {
									type:        "integer"
									minimum:     0
									description: "Hosts count"
								}
								status: {
									type:        "string"
									description: "Status"
								}
								taskID: {
									type:        "string"
									description: "Current task id"
								}
								taskIDsStarted: {
									type:        "array"
									description: "Started task ids"
									items: type: "string"
								}
								taskIDsCompleted: {
									type:        "array"
									description: "Completed task ids"
									items: type: "string"
								}
								action: {
									type:        "string"
									description: "Action"
								}
								actions: {
									type:        "array"
									description: "Actions"
									items: type: "string"
								}
								error: {
									type:        "string"
									description: "Last error"
								}
								errors: {
									type:        "array"
									description: "Errors"
									items: type: "string"
								}
								updated: {
									type:        "integer"
									minimum:     0
									description: "Updated Hosts count"
								}
								added: {
									type:        "integer"
									minimum:     0
									description: "Added Hosts count"
								}
								deleted: {
									type:        "integer"
									minimum:     0
									description: "Deleted Hosts count"
								}
								delete: {
									type:        "integer"
									minimum:     0
									description: "About to delete Hosts count"
								}
								pods: {
									type:        "array"
									description: "Pods"
									items: type: "string"
								}
								fqdns: {
									type:        "array"
									description: "Pods FQDNs"
									items: type: "string"
								}
								endpoint: {
									type:        "string"
									description: "Endpoint"
								}
								generation: {
									type:        "integer"
									minimum:     0
									description: "Generation"
								}
								normalized: {
									type:                                   "object"
									description:                            "Normalized CHI"
									"x-kubernetes-preserve-unknown-fields": true
								}
							}
						}
						spec: {
							type: "object"
							description: """
										Specification of the desired behavior of one or more ClickHouse clusters
										More info: https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md"

										"""
							properties: {
								taskID: {
									type:        "string"
									description: "Allow define custom taskID for named update and watch status of this update execution in .status.taskIDs field, by default every update of chi manifest will generate random taskID"
								}
								stop: {
									type: "string"
									description: """
												Allow stop all ClickHouse clusters described in current chi.
												Stop mechanism works as follows:
												 - When `stop` is `1` then setup `Replicas: 0` in each related to current `chi` StatefulSet resource, all `Pods` and `Service` resources will desctroy, but PVCs still live
												 - When `stop` is `0` then `Pods` will created again and will attach retained PVCs and `Service` also will created again

												"""
									enum: ["", "0", "1", "False", "false", "True", "true", "No", "no", "Yes", "yes", "Off", "off", "On", "on", "Disable", "disable", "Enable", "enable", "Disabled", "disabled", "Enabled", "enabled"]
								}
								restart: {
									type:        "string"
									description: "restart policy for StatefulSets. When value `RollingUpdate` it allow graceful restart one by one instead of restart all StatefulSet simultaneously"
									enum: ["", "RollingUpdate"]
								}
								troubleshoot: {
									type:        "string"
									description: "allows troubleshoot Pods during CrashLoopBack state, when you apply wrong configuration, `clickhouse-server` wouldn't startup"
									enum: ["", "0", "1", "False", "false", "True", "true", "No", "no", "Yes", "yes", "Off", "off", "On", "on", "Disable", "disable", "Enable", "enable", "Disabled", "disabled", "Enabled", "enabled"]
								}
								namespaceDomainPattern: {
									type:        "string"
									description: "custom domain suffix which will add to end of `Service` or `Pod` name, use it when you use custom cluster domain in your Kubernetes cluster"
								}
								templating: {
									type:        "object"
									description: "optional, define policy for auto applying ClickHouseInstallationTemplate inside ClickHouseInstallation"
									properties: policy: {
										type:        "string"
										description: "when defined as `auto` inside ClickhouseInstallationTemplate, it will auto add into all ClickHouseInstallation, manual value is default"
										enum: ["auto", "manual"]
									}
								}
								reconciling: {
									type:        "object"
									description: "optional, allows tuning reconciling cycle for ClickhouseInstallation from clickhouse-operator side"
									properties: {
										policy: type: "string"
										configMapPropagationTimeout: {
											type: "integer"
											description: """
														timeout in seconds when `clickhouse-operator` will wait when applied `ConfigMap` during reconcile `ClickhouseInstallation` pods will updated from cache
														see details: https://kubernetes.io/docs/concepts/configuration/configmap/#mounted-configmaps-are-updated-automatically

														"""
											minimum: 0
											maximum: 3600
										}
										cleanup: {
											type:        "object"
											description: "optional, define behavior for cleanup Kubernetes resources during reconcile cycle"
											properties: {
												unknownObjects: {
													type:        "object"
													description: "what clickhouse-operator shall do when found Kubernetes resources which should be managed with clickhouse-operator, but not have `ownerReference` to any currently managed `ClickHouseInstallation` resource, default behavior is `Delete`"
													properties: {
														statefulSet: {
															type:        "string"
															description: "behavior policy for unknown StatefulSet, Delete by default"
															enum: ["Retain", "Delete"]
														}
														pvc: {
															type:        "string"
															description: "behavior policy for unknown PVC, Delete by default"
															enum: ["Retain", "Delete"]
														}
														configMap: {
															type:        "string"
															description: "behavior policy for unknown ConfigMap, Delete by default"
															enum: ["Retain", "Delete"]
														}
														service: {
															type:        "string"
															description: "behavior policy for unknown Service, Delete by default"
															enum: ["Retain", "Delete"]
														}
													}
												}
												reconcileFailedObjects: {
													type:        "object"
													description: "what clickhouse-operator shall do when reconciling Kubernetes resources are failed, default behavior is `Retain`"
													properties: {
														statefulSet: {
															type:        "string"
															description: "behavior policy for failed StatefulSet reconciling, Retain by default"
															enum: ["Retain", "Delete"]
														}
														pvc: {
															type:        "string"
															description: "behavior policy for failed PVC reconciling, Retain by default"
															enum: ["Retain", "Delete"]
														}
														configMap: {
															type:        "string"
															description: "behavior policy for failed ConfigMap reconciling, Retain by default"
															enum: ["Retain", "Delete"]
														}
														service: {
															type:        "string"
															description: "behavior policy for failed Service reconciling, Retain by default"
															enum: ["Retain", "Delete"]
														}
													}
												}
											}
										}
									}
								}
								defaults: {
									type: "object"
									description: """
												define default behavior for whole ClickHouseInstallation, some behavior can be re-define on cluster, shard and replica level
												More info: https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specdefaults

												"""
									properties: {
										replicasUseFQDN: {
											type: "string"
											description: """
														define should replicas be specified by FQDN in `<host></host>`, then "no" then will use short hostname and clickhouse-server will use kubernetes default suffixes for properly DNS lookup
														"yes" by default

														"""
											enum: ["", "0", "1", "False", "false", "True", "true", "No", "no", "Yes", "yes", "Off", "off", "On", "on", "Disable", "disable", "Enable", "enable", "Disabled", "disabled", "Enabled", "enabled"]
										}
										distributedDDL: {
											type: "object"
											description: """
														allows change `<yandex><distributed_ddl></distributed_ddl></yandex>` settings
														More info: https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#server-settings-distributed_ddl

														"""
											properties: profile: {
												type:        "string"
												description: "Settings from this profile will be used to execute DDL queries"
											}
										}
										templates: {
											type:        "object"
											description: "optional, configuration of the templates names which will use for generate Kubernetes resources according to one or more ClickHouse clusters described in current ClickHouseInstallation (chi) resource"
											properties: {
												hostTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure every `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod`"
												}
												podTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters`"
												}
												dataVolumeClaimTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters`"
												}
												logVolumeClaimTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters`"
												}
												serviceTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for one `Service` resource which will created by `clickhouse-operator` which cover all clusters in whole `chi` resource"
												}
												clusterServiceTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each clickhouse cluster described in `chi.spec.configuration.clusters`"
												}
												shardServiceTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each shard inside clickhouse cluster described in `chi.spec.configuration.clusters`"
												}
												replicaServiceTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside each clickhouse cluster described in `chi.spec.configuration.clusters`"
												}
												volumeClaimTemplate: {
													type:        "string"
													description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
												}
											}
										}
									}
								}
								configuration: {
									type:        "object"
									description: "allows configure multiple aspects and behavior for `clickhouse-server` instance and also allows describe multiple `clickhouse-server` clusters inside one `chi` resource"
									properties: {
										zookeeper: {
											type: "object"
											description: """
														allows configure <yandex><zookeeper>..</zookeeper></yandex> section in each `Pod` during generate `ConfigMap` which will mounted in `/etc/clickhouse-server/config.d/`
														`clickhouse-operator` itself doesn't manage Zookeeper, please install Zookeeper separatelly look examples on https://github.com/Altinity/clickhouse-operator/tree/master/deploy/zookeeper/
														currently, zookeeper (or clickhouse-keeper replacement) used for *ReplicatedMergeTree table engines and for `distributed_ddl`
														More details: https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#server-settings_zookeeper

														"""
											properties: {
												nodes: {
													type:        "array"
													description: "describe every available zookeeper cluster node for interaction"
													items: {
														type: "object"
														properties: {
															host: {
																type:        "string"
																description: "dns name or ip address for Zookeeper node"
															}
															port: {
																type:        "integer"
																description: "TCP port which used to connect to Zookeeper node"
																minimum:     0
																maximum:     65535
															}
														}
													}
												}
												session_timeout_ms: {
													type:        "integer"
													description: "session timeout during connect to Zookeeper"
												}
												operation_timeout_ms: {
													type:        "integer"
													description: "one operation timeout during Zookeeper transactions"
												}
												root: {
													type:        "string"
													description: "optional root znode path inside zookeeper to store ClickHouse related data (replication queue or distributed DDL)"
												}
												identity: {
													type:        "string"
													description: "optional access credentials string with `user:password` format used when use digest authorization in Zookeeper"
												}
											}
										}
										users: {
											type: "object"
											description: """
														allows configure <yandex><users>..</users></yandex> section in each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/users.d/`
														you can configure password hashed, authorization restrictions, database level security row filters etc.
														More details: https://clickhouse.tech/docs/en/operations/settings/settings-users/
														Your yaml code will convert to XML, see examples https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specconfigurationusers

														"""
											"x-kubernetes-preserve-unknown-fields": true
										}
										profiles: {
											type: "object"
											description: """
														allows configure <yandex><profiles>..</profiles></yandex> section in each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/users.d/`
														you can configure any aspect of settings profile
														More details: https://clickhouse.tech/docs/en/operations/settings/settings-profiles/
														Your yaml code will convert to XML, see examples https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specconfigurationprofiles

														"""
											"x-kubernetes-preserve-unknown-fields": true
										}
										quotas: {
											type: "object"
											description: """
														allows configure <yandex><quotas>..</quotas></yandex> section in each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/users.d/`
														you can configure any aspect of resource quotas
														More details: https://clickhouse.tech/docs/en/operations/quotas/
														Your yaml code will convert to XML, see examples https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specconfigurationquotas

														"""
											"x-kubernetes-preserve-unknown-fields": true
										}
										settings: {
											type: "object"
											description: """
														allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/`
														More details: https://clickhouse.tech/docs/en/operations/settings/settings/
														Your yaml code will convert to XML, see examples https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specconfigurationsettings

														"""
											"x-kubernetes-preserve-unknown-fields": true
										}
										files: {
											type: "object"
											description: """
														allows define content of any setting file inside each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
														every key in this object is the file name
														every value in this object is the file content
														you can use `!!binary |` and base64 for binary files, see details here https://yaml.org/type/binary.html
														each key could contains prefix like USERS, COMMON, HOST or config.d, users.d, cond.d, wrong prefixes will ignored, subfolders also will ignored
														More details: https://github.com/Altinity/clickhouse-operator/blob/master/docs/chi-examples/05-settings-05-files-nested.yaml

														"""
											"x-kubernetes-preserve-unknown-fields": true
										}
										clusters: {
											type: "array"
											description: """
														describes ClickHouse clusters layout and allows change settings on cluster-level, shard-level and replica-level
														every cluster is a set of StatefulSet, one StatefulSet contains only one Pod with `clickhouse-server`
														all Pods will rendered in <remote_server> part of ClickHouse configs, mounted from ConfigMap as `/etc/clickhouse-server/config.d/chop-generated-remote_servers.xml`
														Clusters will use for Distributed table engine, more details: https://clickhouse.tech/docs/en/engines/table-engines/special/distributed/
														If `cluster` contains zookeeper settings (could be inherited from top `chi` level), when you can create *ReplicatedMergeTree tables

														"""
											items: {
												type: "object"
												properties: {
													name: {
														type:        "string"
														description: "cluster name, used to identify set of ClickHouse servers and wide used during generate names of related Kubernetes resources"
														minLength:   1
														maxLength:   15
														pattern:     "^[a-zA-Z0-9-]{0,15}$"
													}
													zookeeper: {
														type: "object"
														description: """
																	optional, allows configure <yandex><zookeeper>..</zookeeper></yandex> section in each `Pod` only in current ClickHouse cluster, during generate `ConfigMap` which will mounted in `/etc/clickhouse-server/config.d/`
																	override top-level `chi.spec.configuration.zookeeper` settings

																	"""
														properties: {
															nodes: {
																type:        "array"
																description: "describe every available zookeeper cluster node for interaction"
																items: {
																	type: "object"
																	properties: {
																		host: {
																			type:        "string"
																			description: "dns name or ip address for Zookeeper node"
																		}
																		port: {
																			type:        "integer"
																			description: "TCP port which used to connect to Zookeeper node"
																			minimum:     0
																			maximum:     65535
																		}
																	}
																}
															}
															session_timeout_ms: {
																type:        "integer"
																description: "session timeout during connect to Zookeeper"
															}
															operation_timeout_ms: {
																type:        "integer"
																description: "one operation timeout during Zookeeper transactions"
															}
															root: {
																type:        "string"
																description: "optional root znode path inside zookeeper to store ClickHouse related data (replication queue or distributed DDL)"
															}
															identity: {
																type:        "string"
																description: "optional access credentials string with `user:password` format used when use digest authorization in Zookeeper"
															}
														}
													}
													settings: {
														type: "object"
														description: """
																	optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in each `Pod` only in one cluster during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/`
																	override top-level `chi.spec.configuration.settings`
																	More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
													files: {
														type: "object"
														description: """
																	optional, allows define content of any setting file inside each `Pod` on current cluster during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
																	override top-level `chi.spec.configuration.files`

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
													templates: {
														type: "object"
														description: """
																	optional, configuration of the templates names which will use for generate Kubernetes resources according to selected cluster
																	override top-level `chi.spec.configuration.templates`

																	"""
														properties: {
															hostTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure each `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod` only for one cluster"
															}
															podTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one cluster"
															}
															dataVolumeClaimTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one cluster"
															}
															logVolumeClaimTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one cluster"
															}
															serviceTemplate: {
																type:        "string"
																description: "optional, fully ignores for cluster-level"
															}
															clusterServiceTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each clickhouse cluster described in `chi.spec.configuration.clusters` only for one cluster"
															}
															shardServiceTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one cluster"
															}
															replicaServiceTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside each clickhouse cluster described in `chi.spec.configuration.clusters` only for one cluster"
															}
															volumeClaimTemplate: {
																type:        "string"
																description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
															}
														}
													}
													layout: {
														type: "object"
														description: """
																	describe current cluster layout, how much shards in cluster, how much replica in shard
																	allows override settings on each shard and replica separatelly

																	"""
														properties: {
															type: {
																type:        "string"
																description: "DEPRECATED - to be removed soon"
															}
															shardsCount: {
																type:        "integer"
																description: "how much shards for current ClickHouse cluster will run in Kubernetes, each shard contains shared-nothing part of data and contains set of replicas, cluster contains 1 shard by default"
															}
															replicasCount: {
																type:        "integer"
																description: "how much replicas in each shards for current ClickHouse cluster will run in Kubernetes, each replica is a separate `StatefulSet` which contains only one `Pod` with `clickhouse-server` instance, every shard contains 1 replica by default"
															}
															shards: {
																type:        "array"
																description: "optional, allows override top-level `chi.spec.configuration`, cluster-level `chi.spec.configuration.clusters` settings for each shard separately, use it only if you fully understand what you do"
																items: {
																	type: "object"
																	properties: {
																		name: {
																			type:        "string"
																			description: "optional, by default shard name is generated, but you can override it and setup custom name"
																			minLength:   1
																			maxLength:   15
																			pattern:     "^[a-zA-Z0-9-]{0,15}$"
																		}
																		definitionType: {
																			type:        "string"
																			description: "DEPRECATED - to be removed soon"
																		}
																		weight: {
																			type: "integer"
																			description: """
																						optional, 1 by default, allows setup shard <weight> setting which will use during insert into tables with `Distributed` engine,
																						will apply in <remote_servers> inside ConfigMap which will mount in /etc/clickhouse-server/config.d/chop-generated-remote_servers.xml
																						More details: https://clickhouse.tech/docs/en/engines/table-engines/special/distributed/

																						"""
																		}
																		internalReplication: {
																			type: "string"
																			description: """
																						optional, `true` by default when `chi.spec.configuration.clusters[].layout.ReplicaCount` > 1 and 0 otherwise
																						allows setup <internal_replication> setting which will use during insert into tables with `Distributed` engine for insert only in one live replica and other replicas will download inserted data during replication,
																						will apply in <remote_servers> inside ConfigMap which will mount in /etc/clickhouse-server/config.d/chop-generated-remote_servers.xml
																						More details: https://clickhouse.tech/docs/en/engines/table-engines/special/distributed/

																						"""
																			enum: ["", "0", "1", "False", "false", "True", "true", "No", "no", "Yes", "yes", "Off", "off", "On", "on", "Disable", "disable", "Enable", "enable", "Disabled", "disabled", "Enabled", "enabled"]
																		}
																		settings: {
																			type: "object"
																			description: """
																						optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in each `Pod` only in one shard during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/`
																						override top-level `chi.spec.configuration.settings` and cluster-level `chi.spec.configuration.clusters.settings`
																						More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																						"""
																			"x-kubernetes-preserve-unknown-fields": true
																		}
																		files: {
																			type: "object"
																			description: """
																						optional, allows define content of any setting file inside each `Pod` only in one shard during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
																						override top-level `chi.spec.configuration.files` and cluster-level `chi.spec.configuration.clusters.files`

																						"""
																			"x-kubernetes-preserve-unknown-fields": true
																		}
																		templates: {
																			type: "object"
																			description: """
																						optional, configuration of the templates names which will use for generate Kubernetes resources according to selected shard
																						override top-level `chi.spec.configuration.templates` and cluster-level `chi.spec.configuration.clusters.templates`

																						"""
																			properties: {
																				hostTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure each `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod` only for one shard"
																				}
																				podTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				dataVolumeClaimTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				logVolumeClaimTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				serviceTemplate: {
																					type:        "string"
																					description: "optional, fully ignores for shard-level"
																				}
																				clusterServiceTemplate: {
																					type:        "string"
																					description: "optional, fully ignores for shard-level"
																				}
																				shardServiceTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				replicaServiceTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				volumeClaimTemplate: {
																					type:        "string"
																					description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
																				}
																			}
																		}
																		replicasCount: {
																			type: "integer"
																			description: """
																						optional, how much replicas in selected shard for selected ClickHouse cluster will run in Kubernetes, each replica is a separate `StatefulSet` which contains only one `Pod` with `clickhouse-server` instance,
																						shard contains 1 replica by default
																						override cluster-level `chi.spec.configuration.clusters.layout.replicasCount`

																						"""
																			minimum: 1
																		}
																		replicas: {
																			type: "array"
																			description: """
																						optional, allows override behavior for selected replicas from cluster-level `chi.spec.configuration.clusters` and shard-level `chi.spec.configuration.clusters.layout.shards`

																						"""
																			items: {
																				type: "object"
																				properties: {
																					name: {
																						type:        "string"
																						description: "optional, by default replica name is generated, but you can override it and setup custom name"
																						minLength:   1
																						maxLength:   15
																						pattern:     "^[a-zA-Z0-9-]{0,15}$"
																					}
																					tcpPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `tcp` for selected replica, override `chi.spec.templates.hostTemplates.spec.tcpPort`
																									allows connect to `clickhouse-server` via TCP Native protocol via kubernetes `Service`

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					httpPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `http` for selected replica, override `chi.spec.templates.hostTemplates.spec.httpPort`
																									allows connect to `clickhouse-server` via HTTP protocol via kubernetes `Service`

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					interserverHTTPPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `interserver` for selected replica, override `chi.spec.templates.hostTemplates.spec.interserverHTTPPort`
																									allows connect between replicas inside same shard during fetch replicated data parts HTTP protocol

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					settings: {
																						type: "object"
																						description: """
																									optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in `Pod` only in one replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/conf.d/`
																									override top-level `chi.spec.configuration.settings`, cluster-level `chi.spec.configuration.clusters.settings` and shard-level `chi.spec.configuration.clusters.layout.shards.settings`
																									More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																									"""
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					files: {
																						type: "object"
																						description: """
																									optional, allows define content of any setting file inside `Pod` only in one replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
																									override top-level `chi.spec.configuration.files`, cluster-level `chi.spec.configuration.clusters.files` and shard-level `chi.spec.configuration.clusters.layout.shards.files`

																									"""
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					templates: {
																						type: "object"
																						description: """
																									optional, configuration of the templates names which will use for generate Kubernetes resources according to selected replica
																									override top-level `chi.spec.configuration.templates`, cluster-level `chi.spec.configuration.clusters.templates` and shard-level `chi.spec.configuration.clusters.layout.shards.templates`

																									"""
																						properties: {
																							hostTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod` only for one replica"
																							}
																							podTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one replica"
																							}
																							dataVolumeClaimTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							logVolumeClaimTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							serviceTemplate: {
																								type:        "string"
																								description: "optional, fully ignores for replica-level"
																							}
																							clusterServiceTemplate: {
																								type:        "string"
																								description: "optional, fully ignores for replica-level"
																							}
																							shardServiceTemplate: {
																								type:        "string"
																								description: "optional, fully ignores for replica-level"
																							}
																							replicaServiceTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one replica"
																							}
																							volumeClaimTemplate: {
																								type:        "string"
																								description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
																							}
																						}
																					}
																				}
																			}
																		}
																	}
																}
															}
															replicas: {
																type:        "array"
																description: "optional, allows override top-level `chi.spec.configuration` and cluster-level `chi.spec.configuration.clusters` configuration for each replica and each shard relates to selected replica, use it only if you fully understand what you do"
																items: {
																	type: "object"
																	properties: {
																		name: {
																			type:        "string"
																			description: "optional, by default replica name is generated, but you can override it and setup custom name"
																			minLength:   1
																			maxLength:   15
																			pattern:     "^[a-zA-Z0-9-]{0,15}$"
																		}
																		settings: {
																			type: "object"
																			description: """
																						optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in `Pod` only in one replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/conf.d/`
																						override top-level `chi.spec.configuration.settings`, cluster-level `chi.spec.configuration.clusters.settings` and will ignore if shard-level `chi.spec.configuration.clusters.layout.shards` present
																						More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																						"""
																			"x-kubernetes-preserve-unknown-fields": true
																		}
																		files: {
																			type: "object"
																			description: """
																						optional, allows define content of any setting file inside each `Pod` only in one replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
																						override top-level `chi.spec.configuration.files` and cluster-level `chi.spec.configuration.clusters.files`, will ignore if `chi.spec.configuration.clusters.layout.shards` presents

																						"""
																			"x-kubernetes-preserve-unknown-fields": true
																		}
																		templates: {
																			type: "object"
																			description: """
																						optional, configuration of the templates names which will use for generate Kubernetes resources according to selected replica
																						override top-level `chi.spec.configuration.templates`, cluster-level `chi.spec.configuration.clusters.templates`

																						"""
																			properties: {
																				hostTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod` only for one replica"
																				}
																				podTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one replica"
																				}
																				dataVolumeClaimTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				logVolumeClaimTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				serviceTemplate: {
																					type:        "string"
																					description: "optional, fully ignores for replica-level"
																				}
																				clusterServiceTemplate: {
																					type:        "string"
																					description: "optional, fully ignores for replica-level"
																				}
																				shardServiceTemplate: {
																					type:        "string"
																					description: "optional, fully ignores for replica-level"
																				}
																				replicaServiceTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one replica"
																				}
																				volumeClaimTemplate: {
																					type:        "string"
																					description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
																				}
																			}
																		}
																		shardsCount: {
																			type:        "integer"
																			description: "optional, count of shards related to current replica, you can override each shard behavior on low-level `chi.spec.configuration.clusters.layout.replicas.shards`"
																			minimum:     1
																		}
																		shards: {
																			type:        "array"
																			description: "optional, list of shards related to current replica, will ignore if `chi.spec.configuration.clusters.layout.shards` presents"
																			items: {
																				type: "object"
																				properties: {
																					name: {
																						type:        "string"
																						description: "optional, by default shard name is generated, but you can override it and setup custom name"
																						minLength:   1
																						maxLength:   15
																						pattern:     "^[a-zA-Z0-9-]{0,15}$"
																					}
																					tcpPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `tcp` for selected shard, override `chi.spec.templates.hostTemplates.spec.tcpPort`
																									allows connect to `clickhouse-server` via TCP Native protocol via kubernetes `Service`

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					httpPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `http` for selected shard, override `chi.spec.templates.hostTemplates.spec.httpPort`
																									allows connect to `clickhouse-server` via HTTP protocol via kubernetes `Service`

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					interserverHTTPPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `interserver` for selected shard, override `chi.spec.templates.hostTemplates.spec.interserverHTTPPort`
																									allows connect between replicas inside same shard during fetch replicated data parts HTTP protocol

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					settings: {
																						type: "object"
																						description: """
																									optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in `Pod` only in one shard related to current replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/conf.d/`
																									override top-level `chi.spec.configuration.settings`, cluster-level `chi.spec.configuration.clusters.settings` and replica-level `chi.spec.configuration.clusters.layout.replicas.settings`
																									More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																									"""
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					files: {
																						type: "object"
																						description: """
																									optional, allows define content of any setting file inside each `Pod` only in one shard related to current replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
																									override top-level `chi.spec.configuration.files` and cluster-level `chi.spec.configuration.clusters.files`, will ignore if `chi.spec.configuration.clusters.layout.shards` presents

																									"""
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					templates: {
																						type: "object"
																						description: """
																									optional, configuration of the templates names which will use for generate Kubernetes resources according to selected replica
																									override top-level `chi.spec.configuration.templates`, cluster-level `chi.spec.configuration.clusters.templates`, replica-level `chi.spec.configuration.clusters.layout.replicas.templates`

																									"""
																						properties: {
																							hostTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure each `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod` only for one shard"
																							}
																							podTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							dataVolumeClaimTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							logVolumeClaimTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							serviceTemplate: {
																								type:        "string"
																								description: "optional, fully ignores for shard-level"
																							}
																							clusterServiceTemplate: {
																								type:        "string"
																								description: "optional, fully ignores for shard-level"
																							}
																							shardServiceTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							replicaServiceTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							volumeClaimTemplate: {
																								type:        "string"
																								description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
																							}
																						}
																					}
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
								templates: {
									type:        "object"
									description: "allows define templates which will use for render Kubernetes resources like StatefulSet, ConfigMap, Service, PVC, by default, clickhouse-operator have own templates, but you can override it"
									properties: {
										hostTemplates: {
											type:        "array"
											description: "hostTemplate will use during apply to generate `clickhose-server` config files"
											items: {
												type: "object"
												properties: {
													name: {
														description: "template name, could use to link inside top-level `chi.spec.defaults.templates.hostTemplate`, cluster-level `chi.spec.configuration.clusters.templates.hostTemplate`, shard-level `chi.spec.configuration.clusters.layout.shards.temlates.hostTemplate`, replica-level `chi.spec.configuration.clusters.layout.replicas.templates.hostTemplate`"
														type:        "string"
													}
													portDistribution: {
														type:        "array"
														description: "define how will distribute numeric values of named ports in `Pod.spec.containers.ports` and clickhouse-server configs"
														items: {
															type: "object"
															properties: type: {
																type:        "string"
																description: "type of distribution, when `Unspecified` (default value) then all listen ports on clickhouse-server configuration in all Pods will have the same value, when `ClusterScopeIndex` then ports will increment to offset from base value depends on shard and replica index inside cluster with combination of `chi.spec.templates.podTemlates.spec.HostNetwork` it allows setup ClickHouse cluster inside Kubernetes and provide access via external network bypass Kubernetes internal network"
																enum: ["", "Unspecified", "ClusterScopeIndex"]
															}
														}
													}
													spec: {
														type: "object"
														properties: {
															name: {
																type:        "string"
																description: "by default, hostname will generate, but this allows define custom name for each `clickhuse-server`"
																minLength:   1
																maxLength:   15
																pattern:     "^[a-zA-Z0-9-]{0,15}$"
															}
															tcpPort: {
																type: "integer"
																description: """
																			optional, setup `tcp_port` inside `clickhouse-server` settings for each Pod where current template will apply
																			if specified, should have equal value with `chi.spec.templates.podTemplates.spec.containers.ports[name=tcp]`
																			More info: https://clickhouse.tech/docs/en/interfaces/tcp/

																			"""
																minimum: 1
																maximum: 65535
															}
															httpPort: {
																type: "integer"
																description: """
																			optional, setup `http_port` inside `clickhouse-server` settings for each Pod where current template will apply
																			if specified, should have equal value with `chi.spec.templates.podTemplates.spec.containers.ports[name=http]`
																			More info: https://clickhouse.tech/docs/en/interfaces/http/

																			"""
																minimum: 1
																maximum: 65535
															}
															interserverHTTPPort: {
																type: "integer"
																description: """
																			optional, setup `interserver_http_port` inside `clickhouse-server` settings for each Pod where current template will apply
																			if specified, should have equal value with `chi.spec.templates.podTemplates.spec.containers.ports[name=interserver]`
																			More info: https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#interserver-http-port

																			"""
																minimum: 1
																maximum: 65535
															}
															settings: {
																type: "object"
																description: """
																			optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in each `Pod` where this template will apply during generate `ConfigMap` which will mount in `/etc/clickhouse-server/conf.d/`
																			More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																			"""
																"x-kubernetes-preserve-unknown-fields": true
															}
															files: {
																type: "object"
																description: """
																			optional, allows define content of any setting file inside each `Pod` where this template will apply during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`

																			"""
																"x-kubernetes-preserve-unknown-fields": true
															}
															templates: {
																type:        "object"
																description: "be carefull, this part of CRD allows override template inside template, don't use it if you don't understand what you do"
																properties: {
																	hostTemplate: type:            "string"
																	podTemplate: type:             "string"
																	dataVolumeClaimTemplate: type: "string"
																	logVolumeClaimTemplate: type:  "string"
																	serviceTemplate: type:         "string"
																	clusterServiceTemplate: type:  "string"
																	shardServiceTemplate: type:    "string"
																	replicaServiceTemplate: type:  "string"
																}
															}
														}
													}
												}
											}
										}
										podTemplates: {
											type: "array"
											description: """
														podTemplate will use during render `Pod` inside `StatefulSet.spec` and allows define rendered `Pod.spec`, pod scheduling distribution and pod zone
														More information: https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#spectemplatespodtemplates

														"""
											items: {
												type: "object"
												properties: {
													name: {
														type:        "string"
														description: "template name, could use to link inside top-level `chi.spec.defaults.templates.podTemplate`, cluster-level `chi.spec.configuration.clusters.templates.podTemplate`, shard-level `chi.spec.configuration.clusters.layout.shards.temlates.podTemplate`, replica-level `chi.spec.configuration.clusters.layout.replicas.templates.podTemplate`"
													}
													generateName: {
														type:        "string"
														description: "allows define format for generated `Pod` name, look to https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#spectemplatesservicetemplates for details about aviailable template variables"
													}
													zone: {
														type:        "object"
														description: "allows define custom zone name and will separate ClickHouse `Pods` between nodes, shortcut for `chi.spec.templates.podTemplates.spec.affinity.podAntiAffinity`"
														properties: {
															key: {
																type:        "string"
																description: "optional, if defined, allows select kubernetes nodes by label with `name` equal `key`"
															}
															values: {
																type:        "array"
																description: "optional, if defined, allows select kubernetes nodes by label with `value` in `values`"
																items: type: "string"
															}
														}
													}
													distribution: {
														type:        "string"
														description: "DEPRECATED, shortcut for `chi.spec.templates.podTemplates.spec.affinity.podAntiAffinity`"
														enum: ["", "Unspecified", "OnePerHost"]
													}
													podDistribution: {
														type:        "array"
														description: "define ClickHouse Pod distibution policy between Kubernetes Nodes inside Shard, Replica, Namespace, CHI, another ClickHouse cluster"
														items: {
															type: "object"
															properties: {
																type: {
																	type:        "string"
																	description: "you can define multiple affinity policy types"
																	enum: ["", "Unspecified", "ClickHouseAntiAffinity", "ShardAntiAffinity", "ReplicaAntiAffinity", "AnotherNamespaceAntiAffinity", "AnotherClickHouseInstallationAntiAffinity", "AnotherClusterAntiAffinity", "MaxNumberPerNode", "NamespaceAffinity", "ClickHouseInstallationAffinity", "ClusterAffinity", "ShardAffinity", "ReplicaAffinity", "PreviousTailAffinity", "CircularReplication"]
																}
																scope: {
																	type:        "string"
																	description: "scope for apply each podDistribution"
																	enum: ["", "Unspecified", "Shard", "Replica", "Cluster", "ClickHouseInstallation", "Namespace"]
																}
																number: {
																	type:        "integer"
																	description: "define, how much ClickHouse Pods could be inside selected scope with selected distribution type"
																	minimum:     0
																	maximum:     65535
																}
																topologyKey: {
																	type:        "string"
																	description: "use for inter-pod affinity look to `pod.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution.podAffinityTerm.topologyKey`, More info: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity"
																}
															}
														}
													}
													spec: {
														type:                                   "object"
														description:                            "allows define whole Pod.spec inside StaefulSet.spec, look to https://kubernetes.io/docs/concepts/workloads/pods/#pod-templates for details"
														"x-kubernetes-preserve-unknown-fields": true
													}
													metadata: {
														type: "object"
														description: """
																	allows pass standard object's metadata from template to Pod
																	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
												}
											}
										}
										volumeClaimTemplates: {
											type:        "array"
											description: "allows define template for rendering `PVC` kubernetes resource, which would use inside `Pod` for mount clickhouse `data`, clickhouse `logs` or something else"
											items: {
												type: "object"
												properties: {
													name: {
														description: """
																	template name, could use to link inside
																	top-level `chi.spec.defaults.templates.dataVolumeClaimTemplate` or `chi.spec.defaults.templates.logVolumeClaimTemplate`,
																	cluster-level `chi.spec.configuration.clusters.templates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.templates.logVolumeClaimTemplate`,
																	shard-level `chi.spec.configuration.clusters.layout.shards.temlates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.layout.shards.temlates.logVolumeClaimTemplate`
																	replica-level `chi.spec.configuration.clusters.layout.replicas.templates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.layout.replicas.templates.logVolumeClaimTemplate`

																	"""
														type: "string"
													}
													reclaimPolicy: {
														type:        "string"
														description: "define behavior of `PVC` deletion policy during delete `Pod`, `Delete` by default, when `Retain` then `PVC` still alive even `Pod` will deleted"
														enum: ["", "Retain", "Delete"]
													}
													metadata: {
														type: "object"
														description: """
																	allows pass standard object's metadata from template to PVC
																	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
													spec: {
														type: "object"
														description: """
																	allows define all aspects of `PVC` resource
																	More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
												}
											}
										}
										serviceTemplates: {
											type: "array"
											description: """
														allows define template for rendering `Service` which would get endpoint from Pods which scoped chi-wide, cluster-wide, shard-wide, replica-wide level

														"""
											items: {
												type: "object"
												properties: {
													name: {
														type: "string"
														description: """
																	template name, could use to link inside
																	chi-level `chi.spec.defaults.templates.serviceTemplate`
																	cluster-level `chi.spec.configuration.clusters.templates.clusterServiceTemplate`
																	shard-level `chi.spec.configuration.clusters.layout.shards.temlates.shardServiceTemplate`
																	replica-level `chi.spec.configuration.clusters.layout.replicas.templates.replicaServiceTemplate` or `chi.spec.configuration.clusters.layout.shards.replicas.replicaServiceTemplate`

																	"""
													}
													generateName: {
														type:        "string"
														description: "allows define format for generated `Service` name, look to https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#spectemplatesservicetemplates for details about aviailable template variables"
													}
													metadata: {
														type: "object"
														description: """
																	allows pass standard object's metadata from template to Service
																	Could be use for define specificly for Cloud Provider metadata which impact to behavior of service
																	More info: https://kubernetes.io/docs/concepts/services-networking/service/

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
													spec: {
														type: "object"
														description: """
																	describe behavior of generated Service
																	More info: https://kubernetes.io/docs/concepts/services-networking/service/

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
												}
											}
										}
									}
								}
								useTemplates: {
									type:        "array"
									description: "list of `ClickHouseInstallationTemplate` (chit) resource names which will merge with current `Chi` manifest during render Kubernetes resources to create related ClickHouse clusters"
									items: {
										type: "object"
										properties: {
											name: {
												type:        "string"
												description: "name of `ClickHouseInstallationTemplate` (chit) resource"
											}
											namespace: {
												type:        "string"
												description: "Kubernetes namespace where need search `chit` resource, depending on `watchNamespaces` settings in `clichouse-operator`"
											}
											useType: {
												type:        "string"
												description: "optional, current strategy is only merge, and current `chi` settings have more priority than merged template `chit`"
												enum: ["", "merge"]
											}
										}
									}
								}
							}
						}
					}
				}
			}]
		}
	}
	"clickhouseinstallationtemplates.clickhouse.altinity.com": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: name: "clickhouseinstallationtemplates.clickhouse.altinity.com"
		spec: {
			group: "clickhouse.altinity.com"
			scope: "Namespaced"
			names: {
				kind:     "ClickHouseInstallationTemplate"
				singular: "clickhouseinstallationtemplate"
				plural:   "clickhouseinstallationtemplates"
				shortNames: ["chit"]
			}
			versions: [{
				name:    "v1"
				served:  true
				storage: true
				additionalPrinterColumns: [{
					name:        "version"
					type:        "string"
					description: "Operator version"
					priority:    1
					jsonPath:    ".status.version"
				}, {
					name:        "clusters"
					type:        "integer"
					description: "Clusters count"
					priority:    0
					jsonPath:    ".status.clusters"
				}, {
					name:        "shards"
					type:        "integer"
					description: "Shards count"
					priority:    1
					jsonPath:    ".status.shards"
				}, {
					name:        "hosts"
					type:        "integer"
					description: "Hosts count"
					priority:    0
					jsonPath:    ".status.hosts"
				}, {
					name:        "taskID"
					type:        "string"
					description: "TaskID"
					priority:    1
					jsonPath:    ".status.taskID"
				}, {
					name:        "status"
					type:        "string"
					description: "CHI status"
					priority:    0
					jsonPath:    ".status.status"
				}, {
					name:        "updated"
					type:        "integer"
					description: "Updated hosts count"
					priority:    1
					jsonPath:    ".status.updated"
				}, {
					name:        "added"
					type:        "integer"
					description: "Added hosts count"
					priority:    1
					jsonPath:    ".status.added"
				}, {
					name:        "deleted"
					type:        "integer"
					description: "Hosts deleted count"
					priority:    1
					jsonPath:    ".status.deleted"
				}, {
					name:        "delete"
					type:        "integer"
					description: "Hosts to be deleted count"
					priority:    1
					jsonPath:    ".status.delete"
				}, {
					name:        "endpoint"
					type:        "string"
					description: "Client access endpoint"
					priority:    1
					jsonPath:    ".status.endpoint"
				}]
				subresources: status: {}
				schema: openAPIV3Schema: {
					description: "define a set of Kubernetes resources (StatefulSet, PVC, Service, ConfigMap) which describe behavior one or more ClickHouse clusters"
					type:        "object"
					required: ["spec"]
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						status: {
							type:        "object"
							description: "Current ClickHouseInstallation manifest status, contains many fields like a normalized configuration, clickhouse-operator version, current action and all applied action list, current taskID and all applied taskIDs and other"
							properties: {
								version: {
									type:        "string"
									description: "Version"
								}
								clusters: {
									type:        "integer"
									minimum:     0
									description: "Clusters count"
								}
								shards: {
									type:        "integer"
									minimum:     0
									description: "Shards count"
								}
								replicas: {
									type:        "integer"
									minimum:     0
									description: "Replicas count"
								}
								hosts: {
									type:        "integer"
									minimum:     0
									description: "Hosts count"
								}
								status: {
									type:        "string"
									description: "Status"
								}
								taskID: {
									type:        "string"
									description: "Current task id"
								}
								taskIDsStarted: {
									type:        "array"
									description: "Started task ids"
									items: type: "string"
								}
								taskIDsCompleted: {
									type:        "array"
									description: "Completed task ids"
									items: type: "string"
								}
								action: {
									type:        "string"
									description: "Action"
								}
								actions: {
									type:        "array"
									description: "Actions"
									items: type: "string"
								}
								error: {
									type:        "string"
									description: "Last error"
								}
								errors: {
									type:        "array"
									description: "Errors"
									items: type: "string"
								}
								updated: {
									type:        "integer"
									minimum:     0
									description: "Updated Hosts count"
								}
								added: {
									type:        "integer"
									minimum:     0
									description: "Added Hosts count"
								}
								deleted: {
									type:        "integer"
									minimum:     0
									description: "Deleted Hosts count"
								}
								delete: {
									type:        "integer"
									minimum:     0
									description: "About to delete Hosts count"
								}
								pods: {
									type:        "array"
									description: "Pods"
									items: type: "string"
								}
								fqdns: {
									type:        "array"
									description: "Pods FQDNs"
									items: type: "string"
								}
								endpoint: {
									type:        "string"
									description: "Endpoint"
								}
								generation: {
									type:        "integer"
									minimum:     0
									description: "Generation"
								}
								normalized: {
									type:                                   "object"
									description:                            "Normalized CHI"
									"x-kubernetes-preserve-unknown-fields": true
								}
							}
						}
						spec: {
							type: "object"
							description: """
										Specification of the desired behavior of one or more ClickHouse clusters
										More info: https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md"

										"""
							properties: {
								taskID: {
									type:        "string"
									description: "Allow define custom taskID for named update and watch status of this update execution in .status.taskIDs field, by default every update of chi manifest will generate random taskID"
								}
								stop: {
									type: "string"
									description: """
												Allow stop all ClickHouse clusters described in current chi.
												Stop mechanism works as follows:
												 - When `stop` is `1` then setup `Replicas: 0` in each related to current `chi` StatefulSet resource, all `Pods` and `Service` resources will desctroy, but PVCs still live
												 - When `stop` is `0` then `Pods` will created again and will attach retained PVCs and `Service` also will created again

												"""
									enum: ["", "0", "1", "False", "false", "True", "true", "No", "no", "Yes", "yes", "Off", "off", "On", "on", "Disable", "disable", "Enable", "enable", "Disabled", "disabled", "Enabled", "enabled"]
								}
								restart: {
									type:        "string"
									description: "restart policy for StatefulSets. When value `RollingUpdate` it allow graceful restart one by one instead of restart all StatefulSet simultaneously"
									enum: ["", "RollingUpdate"]
								}
								troubleshoot: {
									type:        "string"
									description: "allows troubleshoot Pods during CrashLoopBack state, when you apply wrong configuration, `clickhouse-server` wouldn't startup"
									enum: ["", "0", "1", "False", "false", "True", "true", "No", "no", "Yes", "yes", "Off", "off", "On", "on", "Disable", "disable", "Enable", "enable", "Disabled", "disabled", "Enabled", "enabled"]
								}
								namespaceDomainPattern: {
									type:        "string"
									description: "custom domain suffix which will add to end of `Service` or `Pod` name, use it when you use custom cluster domain in your Kubernetes cluster"
								}
								templating: {
									type:        "object"
									description: "optional, define policy for auto applying ClickHouseInstallationTemplate inside ClickHouseInstallation"
									properties: policy: {
										type:        "string"
										description: "when defined as `auto` inside ClickhouseInstallationTemplate, it will auto add into all ClickHouseInstallation, manual value is default"
										enum: ["auto", "manual"]
									}
								}
								reconciling: {
									type:        "object"
									description: "optional, allows tuning reconciling cycle for ClickhouseInstallation from clickhouse-operator side"
									properties: {
										policy: type: "string"
										configMapPropagationTimeout: {
											type: "integer"
											description: """
														timeout in seconds when `clickhouse-operator` will wait when applied `ConfigMap` during reconcile `ClickhouseInstallation` pods will updated from cache
														see details: https://kubernetes.io/docs/concepts/configuration/configmap/#mounted-configmaps-are-updated-automatically

														"""
											minimum: 0
											maximum: 3600
										}
										cleanup: {
											type:        "object"
											description: "optional, define behavior for cleanup Kubernetes resources during reconcile cycle"
											properties: {
												unknownObjects: {
													type:        "object"
													description: "what clickhouse-operator shall do when found Kubernetes resources which should be managed with clickhouse-operator, but not have `ownerReference` to any currently managed `ClickHouseInstallation` resource, default behavior is `Delete`"
													properties: {
														statefulSet: {
															type:        "string"
															description: "behavior policy for unknown StatefulSet, Delete by default"
															enum: ["Retain", "Delete"]
														}
														pvc: {
															type:        "string"
															description: "behavior policy for unknown PVC, Delete by default"
															enum: ["Retain", "Delete"]
														}
														configMap: {
															type:        "string"
															description: "behavior policy for unknown ConfigMap, Delete by default"
															enum: ["Retain", "Delete"]
														}
														service: {
															type:        "string"
															description: "behavior policy for unknown Service, Delete by default"
															enum: ["Retain", "Delete"]
														}
													}
												}
												reconcileFailedObjects: {
													type:        "object"
													description: "what clickhouse-operator shall do when reconciling Kubernetes resources are failed, default behavior is `Retain`"
													properties: {
														statefulSet: {
															type:        "string"
															description: "behavior policy for failed StatefulSet reconciling, Retain by default"
															enum: ["Retain", "Delete"]
														}
														pvc: {
															type:        "string"
															description: "behavior policy for failed PVC reconciling, Retain by default"
															enum: ["Retain", "Delete"]
														}
														configMap: {
															type:        "string"
															description: "behavior policy for failed ConfigMap reconciling, Retain by default"
															enum: ["Retain", "Delete"]
														}
														service: {
															type:        "string"
															description: "behavior policy for failed Service reconciling, Retain by default"
															enum: ["Retain", "Delete"]
														}
													}
												}
											}
										}
									}
								}
								defaults: {
									type: "object"
									description: """
												define default behavior for whole ClickHouseInstallation, some behavior can be re-define on cluster, shard and replica level
												More info: https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specdefaults

												"""
									properties: {
										replicasUseFQDN: {
											type: "string"
											description: """
														define should replicas be specified by FQDN in `<host></host>`, then "no" then will use short hostname and clickhouse-server will use kubernetes default suffixes for properly DNS lookup
														"yes" by default

														"""
											enum: ["", "0", "1", "False", "false", "True", "true", "No", "no", "Yes", "yes", "Off", "off", "On", "on", "Disable", "disable", "Enable", "enable", "Disabled", "disabled", "Enabled", "enabled"]
										}
										distributedDDL: {
											type: "object"
											description: """
														allows change `<yandex><distributed_ddl></distributed_ddl></yandex>` settings
														More info: https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#server-settings-distributed_ddl

														"""
											properties: profile: {
												type:        "string"
												description: "Settings from this profile will be used to execute DDL queries"
											}
										}
										templates: {
											type:        "object"
											description: "optional, configuration of the templates names which will use for generate Kubernetes resources according to one or more ClickHouse clusters described in current ClickHouseInstallation (chi) resource"
											properties: {
												hostTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure every `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod`"
												}
												podTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters`"
												}
												dataVolumeClaimTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters`"
												}
												logVolumeClaimTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters`"
												}
												serviceTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for one `Service` resource which will created by `clickhouse-operator` which cover all clusters in whole `chi` resource"
												}
												clusterServiceTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each clickhouse cluster described in `chi.spec.configuration.clusters`"
												}
												shardServiceTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each shard inside clickhouse cluster described in `chi.spec.configuration.clusters`"
												}
												replicaServiceTemplate: {
													type:        "string"
													description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside each clickhouse cluster described in `chi.spec.configuration.clusters`"
												}
												volumeClaimTemplate: {
													type:        "string"
													description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
												}
											}
										}
									}
								}
								configuration: {
									type:        "object"
									description: "allows configure multiple aspects and behavior for `clickhouse-server` instance and also allows describe multiple `clickhouse-server` clusters inside one `chi` resource"
									properties: {
										zookeeper: {
											type: "object"
											description: """
														allows configure <yandex><zookeeper>..</zookeeper></yandex> section in each `Pod` during generate `ConfigMap` which will mounted in `/etc/clickhouse-server/config.d/`
														`clickhouse-operator` itself doesn't manage Zookeeper, please install Zookeeper separatelly look examples on https://github.com/Altinity/clickhouse-operator/tree/master/deploy/zookeeper/
														currently, zookeeper (or clickhouse-keeper replacement) used for *ReplicatedMergeTree table engines and for `distributed_ddl`
														More details: https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#server-settings_zookeeper

														"""
											properties: {
												nodes: {
													type:        "array"
													description: "describe every available zookeeper cluster node for interaction"
													items: {
														type: "object"
														properties: {
															host: {
																type:        "string"
																description: "dns name or ip address for Zookeeper node"
															}
															port: {
																type:        "integer"
																description: "TCP port which used to connect to Zookeeper node"
																minimum:     0
																maximum:     65535
															}
														}
													}
												}
												session_timeout_ms: {
													type:        "integer"
													description: "session timeout during connect to Zookeeper"
												}
												operation_timeout_ms: {
													type:        "integer"
													description: "one operation timeout during Zookeeper transactions"
												}
												root: {
													type:        "string"
													description: "optional root znode path inside zookeeper to store ClickHouse related data (replication queue or distributed DDL)"
												}
												identity: {
													type:        "string"
													description: "optional access credentials string with `user:password` format used when use digest authorization in Zookeeper"
												}
											}
										}
										users: {
											type: "object"
											description: """
														allows configure <yandex><users>..</users></yandex> section in each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/users.d/`
														you can configure password hashed, authorization restrictions, database level security row filters etc.
														More details: https://clickhouse.tech/docs/en/operations/settings/settings-users/
														Your yaml code will convert to XML, see examples https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specconfigurationusers

														"""
											"x-kubernetes-preserve-unknown-fields": true
										}
										profiles: {
											type: "object"
											description: """
														allows configure <yandex><profiles>..</profiles></yandex> section in each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/users.d/`
														you can configure any aspect of settings profile
														More details: https://clickhouse.tech/docs/en/operations/settings/settings-profiles/
														Your yaml code will convert to XML, see examples https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specconfigurationprofiles

														"""
											"x-kubernetes-preserve-unknown-fields": true
										}
										quotas: {
											type: "object"
											description: """
														allows configure <yandex><quotas>..</quotas></yandex> section in each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/users.d/`
														you can configure any aspect of resource quotas
														More details: https://clickhouse.tech/docs/en/operations/quotas/
														Your yaml code will convert to XML, see examples https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specconfigurationquotas

														"""
											"x-kubernetes-preserve-unknown-fields": true
										}
										settings: {
											type: "object"
											description: """
														allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/`
														More details: https://clickhouse.tech/docs/en/operations/settings/settings/
														Your yaml code will convert to XML, see examples https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specconfigurationsettings

														"""
											"x-kubernetes-preserve-unknown-fields": true
										}
										files: {
											type: "object"
											description: """
														allows define content of any setting file inside each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
														every key in this object is the file name
														every value in this object is the file content
														you can use `!!binary |` and base64 for binary files, see details here https://yaml.org/type/binary.html
														each key could contains prefix like USERS, COMMON, HOST or config.d, users.d, cond.d, wrong prefixes will ignored, subfolders also will ignored
														More details: https://github.com/Altinity/clickhouse-operator/blob/master/docs/chi-examples/05-settings-05-files-nested.yaml

														"""
											"x-kubernetes-preserve-unknown-fields": true
										}
										clusters: {
											type: "array"
											description: """
														describes ClickHouse clusters layout and allows change settings on cluster-level, shard-level and replica-level
														every cluster is a set of StatefulSet, one StatefulSet contains only one Pod with `clickhouse-server`
														all Pods will rendered in <remote_server> part of ClickHouse configs, mounted from ConfigMap as `/etc/clickhouse-server/config.d/chop-generated-remote_servers.xml`
														Clusters will use for Distributed table engine, more details: https://clickhouse.tech/docs/en/engines/table-engines/special/distributed/
														If `cluster` contains zookeeper settings (could be inherited from top `chi` level), when you can create *ReplicatedMergeTree tables

														"""
											items: {
												type: "object"
												properties: {
													name: {
														type:        "string"
														description: "cluster name, used to identify set of ClickHouse servers and wide used during generate names of related Kubernetes resources"
														minLength:   1
														maxLength:   15
														pattern:     "^[a-zA-Z0-9-]{0,15}$"
													}
													zookeeper: {
														type: "object"
														description: """
																	optional, allows configure <yandex><zookeeper>..</zookeeper></yandex> section in each `Pod` only in current ClickHouse cluster, during generate `ConfigMap` which will mounted in `/etc/clickhouse-server/config.d/`
																	override top-level `chi.spec.configuration.zookeeper` settings

																	"""
														properties: {
															nodes: {
																type:        "array"
																description: "describe every available zookeeper cluster node for interaction"
																items: {
																	type: "object"
																	properties: {
																		host: {
																			type:        "string"
																			description: "dns name or ip address for Zookeeper node"
																		}
																		port: {
																			type:        "integer"
																			description: "TCP port which used to connect to Zookeeper node"
																			minimum:     0
																			maximum:     65535
																		}
																	}
																}
															}
															session_timeout_ms: {
																type:        "integer"
																description: "session timeout during connect to Zookeeper"
															}
															operation_timeout_ms: {
																type:        "integer"
																description: "one operation timeout during Zookeeper transactions"
															}
															root: {
																type:        "string"
																description: "optional root znode path inside zookeeper to store ClickHouse related data (replication queue or distributed DDL)"
															}
															identity: {
																type:        "string"
																description: "optional access credentials string with `user:password` format used when use digest authorization in Zookeeper"
															}
														}
													}
													settings: {
														type: "object"
														description: """
																	optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in each `Pod` only in one cluster during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/`
																	override top-level `chi.spec.configuration.settings`
																	More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
													files: {
														type: "object"
														description: """
																	optional, allows define content of any setting file inside each `Pod` on current cluster during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
																	override top-level `chi.spec.configuration.files`

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
													templates: {
														type: "object"
														description: """
																	optional, configuration of the templates names which will use for generate Kubernetes resources according to selected cluster
																	override top-level `chi.spec.configuration.templates`

																	"""
														properties: {
															hostTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure each `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod` only for one cluster"
															}
															podTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one cluster"
															}
															dataVolumeClaimTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one cluster"
															}
															logVolumeClaimTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one cluster"
															}
															serviceTemplate: {
																type:        "string"
																description: "optional, fully ignores for cluster-level"
															}
															clusterServiceTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each clickhouse cluster described in `chi.spec.configuration.clusters` only for one cluster"
															}
															shardServiceTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one cluster"
															}
															replicaServiceTemplate: {
																type:        "string"
																description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside each clickhouse cluster described in `chi.spec.configuration.clusters` only for one cluster"
															}
															volumeClaimTemplate: {
																type:        "string"
																description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
															}
														}
													}
													layout: {
														type: "object"
														description: """
																	describe current cluster layout, how much shards in cluster, how much replica in shard
																	allows override settings on each shard and replica separatelly

																	"""
														properties: {
															type: {
																type:        "string"
																description: "DEPRECATED - to be removed soon"
															}
															shardsCount: {
																type:        "integer"
																description: "how much shards for current ClickHouse cluster will run in Kubernetes, each shard contains shared-nothing part of data and contains set of replicas, cluster contains 1 shard by default"
															}
															replicasCount: {
																type:        "integer"
																description: "how much replicas in each shards for current ClickHouse cluster will run in Kubernetes, each replica is a separate `StatefulSet` which contains only one `Pod` with `clickhouse-server` instance, every shard contains 1 replica by default"
															}
															shards: {
																type:        "array"
																description: "optional, allows override top-level `chi.spec.configuration`, cluster-level `chi.spec.configuration.clusters` settings for each shard separately, use it only if you fully understand what you do"
																items: {
																	type: "object"
																	properties: {
																		name: {
																			type:        "string"
																			description: "optional, by default shard name is generated, but you can override it and setup custom name"
																			minLength:   1
																			maxLength:   15
																			pattern:     "^[a-zA-Z0-9-]{0,15}$"
																		}
																		definitionType: {
																			type:        "string"
																			description: "DEPRECATED - to be removed soon"
																		}
																		weight: {
																			type: "integer"
																			description: """
																						optional, 1 by default, allows setup shard <weight> setting which will use during insert into tables with `Distributed` engine,
																						will apply in <remote_servers> inside ConfigMap which will mount in /etc/clickhouse-server/config.d/chop-generated-remote_servers.xml
																						More details: https://clickhouse.tech/docs/en/engines/table-engines/special/distributed/

																						"""
																		}
																		internalReplication: {
																			type: "string"
																			description: """
																						optional, `true` by default when `chi.spec.configuration.clusters[].layout.ReplicaCount` > 1 and 0 otherwise
																						allows setup <internal_replication> setting which will use during insert into tables with `Distributed` engine for insert only in one live replica and other replicas will download inserted data during replication,
																						will apply in <remote_servers> inside ConfigMap which will mount in /etc/clickhouse-server/config.d/chop-generated-remote_servers.xml
																						More details: https://clickhouse.tech/docs/en/engines/table-engines/special/distributed/

																						"""
																			enum: ["", "0", "1", "False", "false", "True", "true", "No", "no", "Yes", "yes", "Off", "off", "On", "on", "Disable", "disable", "Enable", "enable", "Disabled", "disabled", "Enabled", "enabled"]
																		}
																		settings: {
																			type: "object"
																			description: """
																						optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in each `Pod` only in one shard during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/`
																						override top-level `chi.spec.configuration.settings` and cluster-level `chi.spec.configuration.clusters.settings`
																						More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																						"""
																			"x-kubernetes-preserve-unknown-fields": true
																		}
																		files: {
																			type: "object"
																			description: """
																						optional, allows define content of any setting file inside each `Pod` only in one shard during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
																						override top-level `chi.spec.configuration.files` and cluster-level `chi.spec.configuration.clusters.files`

																						"""
																			"x-kubernetes-preserve-unknown-fields": true
																		}
																		templates: {
																			type: "object"
																			description: """
																						optional, configuration of the templates names which will use for generate Kubernetes resources according to selected shard
																						override top-level `chi.spec.configuration.templates` and cluster-level `chi.spec.configuration.clusters.templates`

																						"""
																			properties: {
																				hostTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure each `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod` only for one shard"
																				}
																				podTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				dataVolumeClaimTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				logVolumeClaimTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				serviceTemplate: {
																					type:        "string"
																					description: "optional, fully ignores for shard-level"
																				}
																				clusterServiceTemplate: {
																					type:        "string"
																					description: "optional, fully ignores for shard-level"
																				}
																				shardServiceTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				replicaServiceTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				volumeClaimTemplate: {
																					type:        "string"
																					description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
																				}
																			}
																		}
																		replicasCount: {
																			type: "integer"
																			description: """
																						optional, how much replicas in selected shard for selected ClickHouse cluster will run in Kubernetes, each replica is a separate `StatefulSet` which contains only one `Pod` with `clickhouse-server` instance,
																						shard contains 1 replica by default
																						override cluster-level `chi.spec.configuration.clusters.layout.replicasCount`

																						"""
																			minimum: 1
																		}
																		replicas: {
																			type: "array"
																			description: """
																						optional, allows override behavior for selected replicas from cluster-level `chi.spec.configuration.clusters` and shard-level `chi.spec.configuration.clusters.layout.shards`

																						"""
																			items: {
																				type: "object"
																				properties: {
																					name: {
																						type:        "string"
																						description: "optional, by default replica name is generated, but you can override it and setup custom name"
																						minLength:   1
																						maxLength:   15
																						pattern:     "^[a-zA-Z0-9-]{0,15}$"
																					}
																					tcpPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `tcp` for selected replica, override `chi.spec.templates.hostTemplates.spec.tcpPort`
																									allows connect to `clickhouse-server` via TCP Native protocol via kubernetes `Service`

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					httpPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `http` for selected replica, override `chi.spec.templates.hostTemplates.spec.httpPort`
																									allows connect to `clickhouse-server` via HTTP protocol via kubernetes `Service`

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					interserverHTTPPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `interserver` for selected replica, override `chi.spec.templates.hostTemplates.spec.interserverHTTPPort`
																									allows connect between replicas inside same shard during fetch replicated data parts HTTP protocol

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					settings: {
																						type: "object"
																						description: """
																									optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in `Pod` only in one replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/conf.d/`
																									override top-level `chi.spec.configuration.settings`, cluster-level `chi.spec.configuration.clusters.settings` and shard-level `chi.spec.configuration.clusters.layout.shards.settings`
																									More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																									"""
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					files: {
																						type: "object"
																						description: """
																									optional, allows define content of any setting file inside `Pod` only in one replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
																									override top-level `chi.spec.configuration.files`, cluster-level `chi.spec.configuration.clusters.files` and shard-level `chi.spec.configuration.clusters.layout.shards.files`

																									"""
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					templates: {
																						type: "object"
																						description: """
																									optional, configuration of the templates names which will use for generate Kubernetes resources according to selected replica
																									override top-level `chi.spec.configuration.templates`, cluster-level `chi.spec.configuration.clusters.templates` and shard-level `chi.spec.configuration.clusters.layout.shards.templates`

																									"""
																						properties: {
																							hostTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod` only for one replica"
																							}
																							podTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one replica"
																							}
																							dataVolumeClaimTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							logVolumeClaimTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							serviceTemplate: {
																								type:        "string"
																								description: "optional, fully ignores for replica-level"
																							}
																							clusterServiceTemplate: {
																								type:        "string"
																								description: "optional, fully ignores for replica-level"
																							}
																							shardServiceTemplate: {
																								type:        "string"
																								description: "optional, fully ignores for replica-level"
																							}
																							replicaServiceTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one replica"
																							}
																							volumeClaimTemplate: {
																								type:        "string"
																								description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
																							}
																						}
																					}
																				}
																			}
																		}
																	}
																}
															}
															replicas: {
																type:        "array"
																description: "optional, allows override top-level `chi.spec.configuration` and cluster-level `chi.spec.configuration.clusters` configuration for each replica and each shard relates to selected replica, use it only if you fully understand what you do"
																items: {
																	type: "object"
																	properties: {
																		name: {
																			type:        "string"
																			description: "optional, by default replica name is generated, but you can override it and setup custom name"
																			minLength:   1
																			maxLength:   15
																			pattern:     "^[a-zA-Z0-9-]{0,15}$"
																		}
																		settings: {
																			type: "object"
																			description: """
																						optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in `Pod` only in one replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/conf.d/`
																						override top-level `chi.spec.configuration.settings`, cluster-level `chi.spec.configuration.clusters.settings` and will ignore if shard-level `chi.spec.configuration.clusters.layout.shards` present
																						More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																						"""
																			"x-kubernetes-preserve-unknown-fields": true
																		}
																		files: {
																			type: "object"
																			description: """
																						optional, allows define content of any setting file inside each `Pod` only in one replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
																						override top-level `chi.spec.configuration.files` and cluster-level `chi.spec.configuration.clusters.files`, will ignore if `chi.spec.configuration.clusters.layout.shards` presents

																						"""
																			"x-kubernetes-preserve-unknown-fields": true
																		}
																		templates: {
																			type: "object"
																			description: """
																						optional, configuration of the templates names which will use for generate Kubernetes resources according to selected replica
																						override top-level `chi.spec.configuration.templates`, cluster-level `chi.spec.configuration.clusters.templates`

																						"""
																			properties: {
																				hostTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod` only for one replica"
																				}
																				podTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one replica"
																				}
																				dataVolumeClaimTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				logVolumeClaimTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																				}
																				serviceTemplate: {
																					type:        "string"
																					description: "optional, fully ignores for replica-level"
																				}
																				clusterServiceTemplate: {
																					type:        "string"
																					description: "optional, fully ignores for replica-level"
																				}
																				shardServiceTemplate: {
																					type:        "string"
																					description: "optional, fully ignores for replica-level"
																				}
																				replicaServiceTemplate: {
																					type:        "string"
																					description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one replica"
																				}
																				volumeClaimTemplate: {
																					type:        "string"
																					description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
																				}
																			}
																		}
																		shardsCount: {
																			type:        "integer"
																			description: "optional, count of shards related to current replica, you can override each shard behavior on low-level `chi.spec.configuration.clusters.layout.replicas.shards`"
																			minimum:     1
																		}
																		shards: {
																			type:        "array"
																			description: "optional, list of shards related to current replica, will ignore if `chi.spec.configuration.clusters.layout.shards` presents"
																			items: {
																				type: "object"
																				properties: {
																					name: {
																						type:        "string"
																						description: "optional, by default shard name is generated, but you can override it and setup custom name"
																						minLength:   1
																						maxLength:   15
																						pattern:     "^[a-zA-Z0-9-]{0,15}$"
																					}
																					tcpPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `tcp` for selected shard, override `chi.spec.templates.hostTemplates.spec.tcpPort`
																									allows connect to `clickhouse-server` via TCP Native protocol via kubernetes `Service`

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					httpPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `http` for selected shard, override `chi.spec.templates.hostTemplates.spec.httpPort`
																									allows connect to `clickhouse-server` via HTTP protocol via kubernetes `Service`

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					interserverHTTPPort: {
																						type: "integer"
																						description: """
																									optional, setup `Pod.spec.containers.ports` with name `interserver` for selected shard, override `chi.spec.templates.hostTemplates.spec.interserverHTTPPort`
																									allows connect between replicas inside same shard during fetch replicated data parts HTTP protocol

																									"""
																						minimum: 1
																						maximum: 65535
																					}
																					settings: {
																						type: "object"
																						description: """
																									optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in `Pod` only in one shard related to current replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/conf.d/`
																									override top-level `chi.spec.configuration.settings`, cluster-level `chi.spec.configuration.clusters.settings` and replica-level `chi.spec.configuration.clusters.layout.replicas.settings`
																									More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																									"""
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					files: {
																						type: "object"
																						description: """
																									optional, allows define content of any setting file inside each `Pod` only in one shard related to current replica during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`
																									override top-level `chi.spec.configuration.files` and cluster-level `chi.spec.configuration.clusters.files`, will ignore if `chi.spec.configuration.clusters.layout.shards` presents

																									"""
																						"x-kubernetes-preserve-unknown-fields": true
																					}
																					templates: {
																						type: "object"
																						description: """
																									optional, configuration of the templates names which will use for generate Kubernetes resources according to selected replica
																									override top-level `chi.spec.configuration.templates`, cluster-level `chi.spec.configuration.clusters.templates`, replica-level `chi.spec.configuration.clusters.layout.replicas.templates`

																									"""
																						properties: {
																							hostTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.hostTemplates, which will apply to configure each `clickhouse-server` instance during render ConfigMap resources which will mount into `Pod` only for one shard"
																							}
																							podTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.podTemplates, allows customization each `Pod` resource during render and reconcile each StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							dataVolumeClaimTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse data directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							logVolumeClaimTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.volumeClaimTemplates, allows customization each `PVC` which will mount for clickhouse log directory in each `Pod` during render and reconcile every StatefulSet.spec resource described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							serviceTemplate: {
																								type:        "string"
																								description: "optional, fully ignores for shard-level"
																							}
																							clusterServiceTemplate: {
																								type:        "string"
																								description: "optional, fully ignores for shard-level"
																							}
																							shardServiceTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							replicaServiceTemplate: {
																								type:        "string"
																								description: "optional, template name from chi.spec.templates.serviceTemplates, allows customization for each `Service` resource which will created by `clickhouse-operator` which cover each replica inside each shard inside clickhouse cluster described in `chi.spec.configuration.clusters` only for one shard"
																							}
																							volumeClaimTemplate: {
																								type:        "string"
																								description: "DEPRECATED! VolumeClaimTemplate is deprecated in favor of DataVolumeClaimTemplate and LogVolumeClaimTemplate"
																							}
																						}
																					}
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
								templates: {
									type:        "object"
									description: "allows define templates which will use for render Kubernetes resources like StatefulSet, ConfigMap, Service, PVC, by default, clickhouse-operator have own templates, but you can override it"
									properties: {
										hostTemplates: {
											type:        "array"
											description: "hostTemplate will use during apply to generate `clickhose-server` config files"
											items: {
												type: "object"
												properties: {
													name: {
														description: "template name, could use to link inside top-level `chi.spec.defaults.templates.hostTemplate`, cluster-level `chi.spec.configuration.clusters.templates.hostTemplate`, shard-level `chi.spec.configuration.clusters.layout.shards.temlates.hostTemplate`, replica-level `chi.spec.configuration.clusters.layout.replicas.templates.hostTemplate`"
														type:        "string"
													}
													portDistribution: {
														type:        "array"
														description: "define how will distribute numeric values of named ports in `Pod.spec.containers.ports` and clickhouse-server configs"
														items: {
															type: "object"
															properties: type: {
																type:        "string"
																description: "type of distribution, when `Unspecified` (default value) then all listen ports on clickhouse-server configuration in all Pods will have the same value, when `ClusterScopeIndex` then ports will increment to offset from base value depends on shard and replica index inside cluster with combination of `chi.spec.templates.podTemlates.spec.HostNetwork` it allows setup ClickHouse cluster inside Kubernetes and provide access via external network bypass Kubernetes internal network"
																enum: ["", "Unspecified", "ClusterScopeIndex"]
															}
														}
													}
													spec: {
														type: "object"
														properties: {
															name: {
																type:        "string"
																description: "by default, hostname will generate, but this allows define custom name for each `clickhuse-server`"
																minLength:   1
																maxLength:   15
																pattern:     "^[a-zA-Z0-9-]{0,15}$"
															}
															tcpPort: {
																type: "integer"
																description: """
																			optional, setup `tcp_port` inside `clickhouse-server` settings for each Pod where current template will apply
																			if specified, should have equal value with `chi.spec.templates.podTemplates.spec.containers.ports[name=tcp]`
																			More info: https://clickhouse.tech/docs/en/interfaces/tcp/

																			"""
																minimum: 1
																maximum: 65535
															}
															httpPort: {
																type: "integer"
																description: """
																			optional, setup `http_port` inside `clickhouse-server` settings for each Pod where current template will apply
																			if specified, should have equal value with `chi.spec.templates.podTemplates.spec.containers.ports[name=http]`
																			More info: https://clickhouse.tech/docs/en/interfaces/http/

																			"""
																minimum: 1
																maximum: 65535
															}
															interserverHTTPPort: {
																type: "integer"
																description: """
																			optional, setup `interserver_http_port` inside `clickhouse-server` settings for each Pod where current template will apply
																			if specified, should have equal value with `chi.spec.templates.podTemplates.spec.containers.ports[name=interserver]`
																			More info: https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#interserver-http-port

																			"""
																minimum: 1
																maximum: 65535
															}
															settings: {
																type: "object"
																description: """
																			optional, allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in each `Pod` where this template will apply during generate `ConfigMap` which will mount in `/etc/clickhouse-server/conf.d/`
																			More details: https://clickhouse.tech/docs/en/operations/settings/settings/

																			"""
																"x-kubernetes-preserve-unknown-fields": true
															}
															files: {
																type: "object"
																description: """
																			optional, allows define content of any setting file inside each `Pod` where this template will apply during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/` or `/etc/clickhouse-server/conf.d/` or `/etc/clickhouse-server/users.d/`

																			"""
																"x-kubernetes-preserve-unknown-fields": true
															}
															templates: {
																type:        "object"
																description: "be carefull, this part of CRD allows override template inside template, don't use it if you don't understand what you do"
																properties: {
																	hostTemplate: type:            "string"
																	podTemplate: type:             "string"
																	dataVolumeClaimTemplate: type: "string"
																	logVolumeClaimTemplate: type:  "string"
																	serviceTemplate: type:         "string"
																	clusterServiceTemplate: type:  "string"
																	shardServiceTemplate: type:    "string"
																	replicaServiceTemplate: type:  "string"
																}
															}
														}
													}
												}
											}
										}
										podTemplates: {
											type: "array"
											description: """
														podTemplate will use during render `Pod` inside `StatefulSet.spec` and allows define rendered `Pod.spec`, pod scheduling distribution and pod zone
														More information: https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#spectemplatespodtemplates

														"""
											items: {
												type: "object"
												properties: {
													name: {
														type:        "string"
														description: "template name, could use to link inside top-level `chi.spec.defaults.templates.podTemplate`, cluster-level `chi.spec.configuration.clusters.templates.podTemplate`, shard-level `chi.spec.configuration.clusters.layout.shards.temlates.podTemplate`, replica-level `chi.spec.configuration.clusters.layout.replicas.templates.podTemplate`"
													}
													generateName: {
														type:        "string"
														description: "allows define format for generated `Pod` name, look to https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#spectemplatesservicetemplates for details about aviailable template variables"
													}
													zone: {
														type:        "object"
														description: "allows define custom zone name and will separate ClickHouse `Pods` between nodes, shortcut for `chi.spec.templates.podTemplates.spec.affinity.podAntiAffinity`"
														properties: {
															key: {
																type:        "string"
																description: "optional, if defined, allows select kubernetes nodes by label with `name` equal `key`"
															}
															values: {
																type:        "array"
																description: "optional, if defined, allows select kubernetes nodes by label with `value` in `values`"
																items: type: "string"
															}
														}
													}
													distribution: {
														type:        "string"
														description: "DEPRECATED, shortcut for `chi.spec.templates.podTemplates.spec.affinity.podAntiAffinity`"
														enum: ["", "Unspecified", "OnePerHost"]
													}
													podDistribution: {
														type:        "array"
														description: "define ClickHouse Pod distibution policy between Kubernetes Nodes inside Shard, Replica, Namespace, CHI, another ClickHouse cluster"
														items: {
															type: "object"
															properties: {
																type: {
																	type:        "string"
																	description: "you can define multiple affinity policy types"
																	enum: ["", "Unspecified", "ClickHouseAntiAffinity", "ShardAntiAffinity", "ReplicaAntiAffinity", "AnotherNamespaceAntiAffinity", "AnotherClickHouseInstallationAntiAffinity", "AnotherClusterAntiAffinity", "MaxNumberPerNode", "NamespaceAffinity", "ClickHouseInstallationAffinity", "ClusterAffinity", "ShardAffinity", "ReplicaAffinity", "PreviousTailAffinity", "CircularReplication"]
																}
																scope: {
																	type:        "string"
																	description: "scope for apply each podDistribution"
																	enum: ["", "Unspecified", "Shard", "Replica", "Cluster", "ClickHouseInstallation", "Namespace"]
																}
																number: {
																	type:        "integer"
																	description: "define, how much ClickHouse Pods could be inside selected scope with selected distribution type"
																	minimum:     0
																	maximum:     65535
																}
																topologyKey: {
																	type:        "string"
																	description: "use for inter-pod affinity look to `pod.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution.podAffinityTerm.topologyKey`, More info: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity"
																}
															}
														}
													}
													spec: {
														type:                                   "object"
														description:                            "allows define whole Pod.spec inside StaefulSet.spec, look to https://kubernetes.io/docs/concepts/workloads/pods/#pod-templates for details"
														"x-kubernetes-preserve-unknown-fields": true
													}
													metadata: {
														type: "object"
														description: """
																	allows pass standard object's metadata from template to Pod
																	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
												}
											}
										}
										volumeClaimTemplates: {
											type:        "array"
											description: "allows define template for rendering `PVC` kubernetes resource, which would use inside `Pod` for mount clickhouse `data`, clickhouse `logs` or something else"
											items: {
												type: "object"
												properties: {
													name: {
														description: """
																	template name, could use to link inside
																	top-level `chi.spec.defaults.templates.dataVolumeClaimTemplate` or `chi.spec.defaults.templates.logVolumeClaimTemplate`,
																	cluster-level `chi.spec.configuration.clusters.templates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.templates.logVolumeClaimTemplate`,
																	shard-level `chi.spec.configuration.clusters.layout.shards.temlates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.layout.shards.temlates.logVolumeClaimTemplate`
																	replica-level `chi.spec.configuration.clusters.layout.replicas.templates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.layout.replicas.templates.logVolumeClaimTemplate`

																	"""
														type: "string"
													}
													reclaimPolicy: {
														type:        "string"
														description: "define behavior of `PVC` deletion policy during delete `Pod`, `Delete` by default, when `Retain` then `PVC` still alive even `Pod` will deleted"
														enum: ["", "Retain", "Delete"]
													}
													metadata: {
														type: "object"
														description: """
																	allows pass standard object's metadata from template to PVC
																	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
													spec: {
														type: "object"
														description: """
																	allows define all aspects of `PVC` resource
																	More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
												}
											}
										}
										serviceTemplates: {
											type: "array"
											description: """
														allows define template for rendering `Service` which would get endpoint from Pods which scoped chi-wide, cluster-wide, shard-wide, replica-wide level

														"""
											items: {
												type: "object"
												properties: {
													name: {
														type: "string"
														description: """
																	template name, could use to link inside
																	chi-level `chi.spec.defaults.templates.serviceTemplate`
																	cluster-level `chi.spec.configuration.clusters.templates.clusterServiceTemplate`
																	shard-level `chi.spec.configuration.clusters.layout.shards.temlates.shardServiceTemplate`
																	replica-level `chi.spec.configuration.clusters.layout.replicas.templates.replicaServiceTemplate` or `chi.spec.configuration.clusters.layout.shards.replicas.replicaServiceTemplate`

																	"""
													}
													generateName: {
														type:        "string"
														description: "allows define format for generated `Service` name, look to https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#spectemplatesservicetemplates for details about aviailable template variables"
													}
													metadata: {
														type: "object"
														description: """
																	allows pass standard object's metadata from template to Service
																	Could be use for define specificly for Cloud Provider metadata which impact to behavior of service
																	More info: https://kubernetes.io/docs/concepts/services-networking/service/

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
													spec: {
														type: "object"
														description: """
																	describe behavior of generated Service
																	More info: https://kubernetes.io/docs/concepts/services-networking/service/

																	"""
														"x-kubernetes-preserve-unknown-fields": true
													}
												}
											}
										}
									}
								}
								useTemplates: {
									type:        "array"
									description: "list of `ClickHouseInstallationTemplate` (chit) resource names which will merge with current `Chi` manifest during render Kubernetes resources to create related ClickHouse clusters"
									items: {
										type: "object"
										properties: {
											name: {
												type:        "string"
												description: "name of `ClickHouseInstallationTemplate` (chit) resource"
											}
											namespace: {
												type:        "string"
												description: "Kubernetes namespace where need search `chit` resource, depending on `watchNamespaces` settings in `clichouse-operator`"
											}
											useType: {
												type:        "string"
												description: "optional, current strategy is only merge, and current `chi` settings have more priority than merged template `chit`"
												enum: ["", "merge"]
											}
										}
									}
								}
							}
						}
					}
				}
			}]
		}
	}
	"clickhouseoperatorconfigurations.clickhouse.altinity.com": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: name: "clickhouseoperatorconfigurations.clickhouse.altinity.com"
		spec: {
			group: "clickhouse.altinity.com"
			scope: "Namespaced"
			names: {
				kind:     "ClickHouseOperatorConfiguration"
				singular: "clickhouseoperatorconfiguration"
				plural:   "clickhouseoperatorconfigurations"
				shortNames: ["chopconf"]
			}
			versions: [{
				name:    "v1"
				served:  true
				storage: true
				additionalPrinterColumns: [{
					name:        "namespaces"
					type:        "string"
					description: "Watch namespaces"
					priority:    0
					jsonPath:    ".status"
				}]
				schema: openAPIV3Schema: {
					type:                                   "object"
					description:                            "allows customize `clickhouse-operator` settings, need restart clickhouse-operator pod after adding, more details https://github.com/Altinity/clickhouse-operator/blob/master/docs/operator_configuration.md"
					"x-kubernetes-preserve-unknown-fields": true
					properties: {
						status: {
							type:                                   "object"
							"x-kubernetes-preserve-unknown-fields": true
						}
						spec: {
							type: "object"
							description: """
										allows define some of settings for `clickhouse-operator` itself,
										More info: https://github.com/Altinity/clickhouse-operator/blob/master/config/config.yaml
										look to etc-clickhouse-operator* ConfigMaps if you need more control

										"""
							"x-kubernetes-preserve-unknown-fields": true
							properties: {
								watchNamespaces: {
									type:        "array"
									description: "List of namespaces where clickhouse-operator watches for events."
									items: type: "string"
								}
								chCommonConfigsPath: {
									type:        "string"
									description: "Path to folder where ClickHouse configuration files common for all instances within CHI are located. Default - config.d"
								}
								chHostConfigsPath: {
									type:        "string"
									description: "Path to folder where ClickHouse configuration files unique for each instance (host) within CHI are located. Default - conf.d"
								}
								chUsersConfigsPath: {
									type:        "string"
									description: "Path to folder where ClickHouse configuration files with users settings are located. Files are common for all instances within CHI"
								}
								chiTemplatesPath: {
									type:        "string"
									description: "Path to folder where ClickHouseInstallation .yaml manifests are located."
								}
								statefulSetUpdateTimeout: {
									type:        "integer"
									description: "How many seconds to wait for created/updated StatefulSet to be Ready"
								}
								statefulSetUpdatePollPeriod: {
									type:        "integer"
									description: "How many seconds to wait between checks for created/updated StatefulSet status"
								}
								onStatefulSetCreateFailureAction: {
									type: "string"
									description: """
												What to do in case created StatefulSet is not in Ready after `statefulSetUpdateTimeout` seconds
												Possible options:
												1. abort - do nothing, just break the process and wait for admin.
												2. delete - delete newly created problematic StatefulSet.
												3. ignore (default) - ignore error, pretend nothing happened and move on to the next StatefulSet.

												"""
								}
								onStatefulSetUpdateFailureAction: {
									type: "string"
									description: """
												What to do in case updated StatefulSet is not in Ready after `statefulSetUpdateTimeout` seconds
												Possible options:
												1. abort - do nothing, just break the process and wait for admin.
												2. rollback (default) - delete Pod and rollback StatefulSet to previous Generation. Pod would be recreated by StatefulSet based on rollback-ed configuration.
												3. ignore - ignore error, pretend nothing happened and move on to the next StatefulSet.

												"""
								}
								chConfigUserDefaultProfile: {
									type:        "string"
									description: "ClickHouse server configuration `<profile>...</profile>` for any <user>"
								}
								chConfigUserDefaultQuota: {
									type:        "string"
									description: "ClickHouse server configuration `<quota>...</quota>` for any <user>"
								}
								chConfigUserDefaultNetworksIP: {
									type:        "array"
									description: "ClickHouse server configuration `<networks><ip>...</ip></networks>` for any <user>"
									items: type: "string"
								}
								chConfigUserDefaultPassword: {
									description: "ClickHouse server configuration `<password>...</password>` for any <user>"
									type:        "string"
								}
								chConfigNetworksHostRegexpTemplate: {
									description: "ClickHouse server configuration `<host_regexp>...</host_regexp>` for any <user>"
									type:        "string"
								}
								chUsername: {
									type:        "string"
									description: "ClickHouse username to be used by operator to connect to ClickHouse instances, deprecated, use chCredentialsSecretName"
								}
								chPassword: {
									type:        "string"
									description: "ClickHouse password to be used by operator to connect to ClickHouse instances, deprecated, use chCredentialsSecretName"
								}
								chCredentialsSecretNamespace: {
									type:        "string"
									description: "Location of k8s Secret with username and password to be used by operator to connect to ClickHouse instances"
								}
								chCredentialsSecretName: {
									type:        "string"
									description: "Name of k8s Secret with username and password to be used by operator to connect to ClickHouse instances"
								}
								chPort: {
									type:        "integer"
									minimum:     1
									maximum:     65535
									description: "Name of k8s Secret with username and password to be used by operator to connect to ClickHouse instances"
								}
								logtostderr: {
									type:        "string"
									description: "boolean, allows logs to stderr"
								}
								alsologtostderr: {
									type:        "string"
									description: "boolean allows logs to stderr and files both"
								}
								v: {
									type:        "string"
									description: "verbosity level of clickhouse-operator log, default - 1 max - 9"
								}
								stderrthreshold: type:  "string"
								vmodule: type:          "string"
								log_backtrace_at: type: "string"
								reconcileThreadsNumber: {
									type:        "integer"
									description: "how much goroutines will use to reconcile in parallel, 10 by default"
									minimum:     1
									maximum:     65535
								}
								reconcileWaitExclude: type: "string"
								reconcileWaitInclude: type: "string"
								excludeFromPropagationLabels: {
									type: "array"
									description: """
												When propagating labels from the chi's `metadata.labels` section to child objects' `metadata.labels`,
												exclude labels from the following list

												"""
									items: type: "string"
								}
								appendScopeLabels: {
									type:        "string"
									description: "Whether to append *Scope* labels to StatefulSet and Pod"
									enum: ["", "0", "1", "False", "false", "True", "true", "No", "no", "Yes", "yes", "Off", "off", "On", "on", "Disable", "disable", "Enable", "enable", "Disabled", "disabled", "Enabled", "enabled", "LabelShardScopeIndex", "LabelReplicaScopeIndex", "LabelCHIScopeIndex", "LabelCHIScopeCycleSize", "LabelCHIScopeCycleIndex", "LabelCHIScopeCycleOffset", "LabelClusterScopeIndex", "LabelClusterScopeCycleSize", "LabelClusterScopeCycleIndex", "LabelClusterScopeCycleOffset"]
								}
							}
						}
					}
				}
			}]
		}
	}
}
