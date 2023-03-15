package k8s

CustomResourceDefinition: "clickhouseinstallations.clickhouse.altinity.com": {
	// Template Parameters:
	//
	// KIND=ClickHouseInstallation
	// SINGULAR=clickhouseinstallation
	// PLURAL=clickhouseinstallations
	// SHORT=chi
	//
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		name: "clickhouseinstallations.clickhouse.altinity.com"
		labels: "clickhouse.altinity.com/chop": "0.20.3"
	}
	spec: {
		group: "clickhouse.altinity.com"
		scope: "Namespaced"
		names: {
			kind:     "ClickHouseInstallation"
			singular: "clickhouseinstallation"
			plural:   "clickhouseinstallations"
			shortNames: [
				"chi",
			]
		}
		versions: [{
			name:    "v1"
			served:  true
			storage: true
			additionalPrinterColumns: [{
				name:        "version"
				type:        "string"
				description: "Operator version"
				priority:    1 // show in wide view
				jsonPath:    ".status.chop-version"
			}, {
				name:        "clusters"
				type:        "integer"
				description: "Clusters count"
				priority:    0 // show in standard view
				jsonPath:    ".status.clusters"
			}, {
				name:        "shards"
				type:        "integer"
				description: "Shards count"
				priority:    1 // show in wide view
				jsonPath:    ".status.shards"
			}, {
				name:        "hosts"
				type:        "integer"
				description: "Hosts count"
				priority:    0 // show in standard view
				jsonPath:    ".status.hosts"
			}, {
				name:        "taskID"
				type:        "string"
				description: "TaskID"
				priority:    1 // show in wide view
				jsonPath:    ".status.taskID"
			}, {
				name:        "status"
				type:        "string"
				description: "CHI status"
				priority:    0 // show in standard view
				jsonPath:    ".status.status"
			}, {
				name:        "hosts-updated"
				type:        "integer"
				description: "Updated hosts count"
				priority:    1 // show in wide view
				jsonPath:    ".status.hostsUpdated"
			}, {
				name:        "hosts-added"
				type:        "integer"
				description: "Added hosts count"
				priority:    1 // show in wide view
				jsonPath:    ".status.hostsAdded"
			}, {
				name:        "hosts-completed"
				type:        "integer"
				description: "Completed hosts count"
				priority:    0 // show in standard view
				jsonPath:    ".status.hostsCompleted"
			}, {
				name:        "hosts-deleted"
				type:        "integer"
				description: "Hosts deleted count"
				priority:    1 // show in wide view
				jsonPath:    ".status.hostsDeleted"
			}, {
				name:        "hosts-delete"
				type:        "integer"
				description: "Hosts to be deleted count"
				priority:    1 // show in wide view
				jsonPath:    ".status.hostsDelete"
			}, {
				name:        "endpoint"
				type:        "string"
				description: "Client access endpoint"
				priority:    1 // show in wide view
				jsonPath:    ".status.endpoint"
			}, {
				name:        "age"
				type:        "date"
				description: "Age of the resource"
				// Displayed in all priorities
				jsonPath: ".metadata.creationTimestamp"
			}]
			subresources: status: {}
			schema: openAPIV3Schema: {
				description: "define a set of Kubernetes resources (StatefulSet, PVC, Service, ConfigMap) which describe behavior one or more ClickHouse clusters"
				type:        "object"
				required: [
					"spec",
				]
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					status: {
						type:        "object"
						description: "Current ClickHouseInstallation manifest status, contains many fields like a normalized configuration, clickhouse-operator version, current action and all applied action list, current taskID and all applied taskIDs and other"
						properties: {
							"chop-version": {
								type:        "string"
								description: "ClickHouse operator version"
							}
							"chop-commit": {
								type:        "string"
								description: "ClickHouse operator git commit SHA"
							}
							"chop-date": {
								type:        "string"
								description: "ClickHouse operator build date"
							}
							"chop-ip": {
								type:        "string"
								description: "IP address of the operator's pod which managed this CHI"
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
							hostsUpdated: {
								type:        "integer"
								minimum:     0
								description: "Updated Hosts count"
							}
							hostsAdded: {
								type:        "integer"
								minimum:     0
								description: "Added Hosts count"
							}
							hostsCompleted: {
								type:        "integer"
								minimum:     0
								description: "Completed Hosts count"
							}
							hostsDeleted: {
								type:        "integer"
								minimum:     0
								description: "Deleted Hosts count"
							}
							hostsDelete: {
								type:        "integer"
								minimum:     0
								description: "About to delete Hosts count"
							}
							pods: {
								type:        "array"
								description: "Pods"
								items: type: "string"
							}
							"pod-ips": {
								type:        "array"
								description: "Pod IPs"
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
								description:                            "Normalized CHI requested"
								"x-kubernetes-preserve-unknown-fields": true
							}
							normalizedCompleted: {
								type:                                   "object"
								description:                            "Normalized CHI completed"
								"x-kubernetes-preserve-unknown-fields": true
							}
						}
					}
					spec: {
						type: "object"
						// x-kubernetes-preserve-unknown-fields: true
						description: """
		Specification of the desired behavior of one or more ClickHouse clusters
		More info: https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md

		"""

						properties: {
							taskID: {
								type: "string"
								description: """
		Allows to define custom taskID for named update operation and watch status of this update execution in .status.taskIDs field.
		By default every update of chi manifest will generate random taskID

		"""
							}

							stop: {
								type: "string"
								description: """
		Allow stop all ClickHouse clusters described in current chi.
		Stop mechanism works as follows:
		 - When `stop` is `1` then setup `Replicas: 0` in each related to current `chi` StatefulSet resource, all `Pods` and `Service` resources will desctroy, but PVCs still live
		 - When `stop` is `0` then `Pods` will created again and will attach retained PVCs and `Service` also will created again

		"""

								enum:
								// List StringBoolXXX constants from model
								[
									"",
									"0",
									"1",
									"False",
									"false",
									"True",
									"true",
									"No",
									"no",
									"Yes",
									"yes",
									"Off",
									"off",
									"On",
									"on",
									"Disable",
									"disable",
									"Enable",
									"enable",
									"Disabled",
									"disabled",
									"Enabled",
									"enabled",
								]
							}
							restart: {
								type:        "string"
								description: "This is a 'soft restart' button. When set to 'RollingUpdate' operator will restart ClickHouse pods in a graceful way. Remove it after the use in order to avoid unneeded restarts"
								enum: [
									"",
									"RollingUpdate",
								]
							}
							troubleshoot: {
								type:        "string"
								description: "allows troubleshoot Pods during CrashLoopBack state, when you apply wrong configuration, `clickhouse-server` wouldn't startup"
								enum: [
									"",
									"0",
									"1",
									"False",
									"false",
									"True",
									"true",
									"No",
									"no",
									"Yes",
									"yes",
									"Off",
									"off",
									"On",
									"on",
									"Disable",
									"disable",
									"Enable",
									"enable",
									"Disabled",
									"disabled",
									"Enabled",
									"enabled",
								]
							}
							namespaceDomainPattern: {
								type:        "string"
								description: "custom domain suffix which will add to end of `Service` or `Pod` name, use it when you use custom cluster domain in your Kubernetes cluster"
							}
							templating: {
								type: "object"
								// nullable: true
								description: "optional, define policy for auto applying ClickHouseInstallationTemplate inside ClickHouseInstallation"
								properties: policy: {
									type:        "string"
									description: "when defined as `auto` inside ClickhouseInstallationTemplate, it will auto add into all ClickHouseInstallation, manual value is default"
									enum: [
										"auto",
										"manual",
									]
								}
							}
							reconciling: {
								type:        "object"
								description: "optional, allows tuning reconciling cycle for ClickhouseInstallation from clickhouse-operator side"
								// nullable: true
								properties: {
									policy: {
										type:        "string"
										description: "DEPRECATED"
									}
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
										// nullable: true
										properties: {
											unknownObjects: {
												type:        "object"
												description: "what clickhouse-operator shall do when found Kubernetes resources which should be managed with clickhouse-operator, but not have `ownerReference` to any currently managed `ClickHouseInstallation` resource, default behavior is `Delete`"
												// nullable: true
												properties: {
													statefulSet: {
														type:        "string"
														description: "behavior policy for unknown StatefulSet, Delete by default"
														enum:
														// List ObjectsCleanupXXX constants from model
														[
															"Retain",
															"Delete",
														]
													}
													pvc: {
														type:        "string"
														description: "behavior policy for unknown PVC, Delete by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
													configMap: {
														type:        "string"
														description: "behavior policy for unknown ConfigMap, Delete by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
													service: {
														type:        "string"
														description: "behavior policy for unknown Service, Delete by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
												}
											}
											reconcileFailedObjects: {
												type:        "object"
												description: "what clickhouse-operator shall do when reconciling Kubernetes resources are failed, default behavior is `Retain`"
												// nullable: true
												properties: {
													statefulSet: {
														type:        "string"
														description: "behavior policy for failed StatefulSet reconciling, Retain by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
													pvc: {
														type:        "string"
														description: "behavior policy for failed PVC reconciling, Retain by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
													configMap: {
														type:        "string"
														description: "behavior policy for failed ConfigMap reconciling, Retain by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
													service: {
														type:        "string"
														description: "behavior policy for failed Service reconciling, Retain by default"
														enum: [
															"Retain",
															"Delete",
														]
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

								// nullable: true
								properties: {
									replicasUseFQDN: {
										type: "string"
										description: """
		define should replicas be specified by FQDN in `<host></host>`.
		In case of \"no\" will use short hostname and clickhouse-server will use kubernetes default suffixes for DNS lookup
		\"yes\" by default

		"""
										enum: [
											"",
											"0",
											"1",
											"False",
											"false",
											"True",
											"true",
											"No",
											"no",
											"Yes",
											"yes",
											"Off",
											"off",
											"On",
											"on",
											"Disable",
											"disable",
											"Enable",
											"enable",
											"Disabled",
											"disabled",
											"Enabled",
											"enabled",
										]
									}

									distributedDDL: {
										type: "object"
										description: """
		allows change `<yandex><distributed_ddl></distributed_ddl></yandex>` settings
		More info: https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#server-settings-distributed_ddl

		"""

										// nullable: true
										properties: {
											profile: {
												type:        "string"
												description: "Settings from this profile will be used to execute DDL queries"
											}
										}
									}
									storageManagement: {
										type:        "object"
										description: "default storage management options"
										properties: {
											provisioner: {
												type:        "string"
												description: "defines `PVC` provisioner - be it StatefulSet or the Operator"
												enum: [
													"",
													"StatefulSet",
													"Operator",
												]
											}
											reclaimPolicy: {
												type: "string"
												description: """
		defines behavior of `PVC` deletion.
		`Delete` by default, if `Retain` specified then `PVC` will be kept when deleting StatefulSet

		"""

												enum: [
													"",
													"Retain",
													"Delete",
												]
											}
										}
									}
									templates: {
										type:        "object"
										description: "optional, configuration of the templates names which will use for generate Kubernetes resources according to one or more ClickHouse clusters described in current ClickHouseInstallation (chi) resource"
										// nullable: true
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
								// nullable: true
								properties: {
									zookeeper: {
										type: "object"
										description: """
		allows configure <yandex><zookeeper>..</zookeeper></yandex> section in each `Pod` during generate `ConfigMap` which will mounted in `/etc/clickhouse-server/config.d/`
		`clickhouse-operator` itself doesn't manage Zookeeper, please install Zookeeper separatelly look examples on https://github.com/Altinity/clickhouse-operator/tree/master/deploy/zookeeper/
		currently, zookeeper (or clickhouse-keeper replacement) used for *ReplicatedMergeTree table engines and for `distributed_ddl`
		More details: https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#server-settings_zookeeper

		"""

										// nullable: true
										properties: {
											nodes: {
												type:        "array"
												description: "describe every available zookeeper cluster node for interaction"
												// nullable: true
												items: {
													type: "object"
													//required:
													//  - host
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

										// nullable: true
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

										// nullable: true
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

										// nullable: true
										"x-kubernetes-preserve-unknown-fields": true
									}
									settings: {
										type: "object"
										description: """
		allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/`
		More details: https://clickhouse.tech/docs/en/operations/settings/settings/
		Your yaml code will convert to XML, see examples https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specconfigurationsettings

		"""

										// nullable: true
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

										// nullable: true
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

										// nullable: true
										items: {
											type: "object"
											//required:
											//  - name
											properties: {
												name: {
													type:        "string"
													description: "cluster name, used to identify set of ClickHouse servers and wide used during generate names of related Kubernetes resources"
													minLength:   1
													// See namePartClusterMaxLen const
													maxLength: 15
													pattern:   "^[a-zA-Z0-9-]{0,15}$"
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

												schemaPolicy: {
													type: "object"
													description: """
		describes how schema is propagated within replicas and shards

		"""

													properties: {
														replica: {
															type:        "string"
															description: "how schema is propagated within a replica"
															enum:
															// List SchemaPolicyReplicaXXX constants from model
															[
																"None",
																"All",
															]
														}
														shard: {
															type:        "string"
															description: "how schema is propagated between shards"
															enum:
															// List SchemaPolicyShardXXX constants from model
															[
																"None",
																"All",
																"DistributedTablesOnly",
															]
														}
													}
												}
												secure: {
													type:        "string"
													description: "optional, setup `secure` inside `clickhouse-server` settings for each Pod of the cluster"
													enum: [
														"",
														"0",
														"1",
														"False",
														"false",
														"True",
														"true",
														"No",
														"no",
														"Yes",
														"yes",
														"Off",
														"off",
														"On",
														"on",
														"Disable",
														"disable",
														"Enable",
														"enable",
														"Disabled",
														"disabled",
														"Enabled",
														"enabled",
													]
												}
												secret: {
													type:        "object"
													description: "optional, shared secret value to secure cluster communications"
													properties: {
														auto: {
															type:        "string"
															description: "Auto-generate shared secret value to secure cluster communications"
															enum: [
																"",
																"0",
																"1",
																"False",
																"false",
																"True",
																"true",
																"No",
																"no",
																"Yes",
																"yes",
																"Off",
																"off",
																"On",
																"on",
																"Disable",
																"disable",
																"Enable",
																"enable",
																"Disabled",
																"disabled",
																"Enabled",
																"enabled",
															]
														}
														value: {
															description: "Cluster shared secret value in plain text"
															type:        "string"
														}
														valueFrom: {
															description: "Cluster shared secret source"
															type:        "object"
															properties: secretKeyRef: {
																description: """
		Selects a key of a secret in the clickhouse installation namespace.
		Should not be used if value is not empty.

		"""

																type: "object"
																properties: {
																	name: {
																		description: """
		Name of the referent. More info:
		https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names

		"""

																		type: "string"
																	}
																	key: {
																		description: "The key of the secret to select from. Must be a valid secret key."
																		type:        "string"
																	}
																	optional: {
																		description: "Specify whether the Secret or its key must be defined"
																		type:        "boolean"
																	}
																}
																required: [
																	"name",
																	"key",
																]
															}
														}
													}
												}
												layout: {
													type: "object"
													description: """
		describe current cluster layout, how much shards in cluster, how much replica in shard
		allows override settings on each shard and replica separatelly

		"""

													// nullable: true
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
															// nullable: true
															items: {
																type: "object"
																properties: {
																	name: {
																		type:        "string"
																		description: "optional, by default shard name is generated, but you can override it and setup custom name"
																		minLength:   1
																		// See namePartShardMaxLen const
																		maxLength: 15
																		pattern:   "^[a-zA-Z0-9-]{0,15}$"
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
																		enum: [
																			"",
																			"0",
																			"1",
																			"False",
																			"false",
																			"True",
																			"true",
																			"No",
																			"no",
																			"Yes",
																			"yes",
																			"Off",
																			"off",
																			"On",
																			"on",
																			"Disable",
																			"disable",
																			"Enable",
																			"enable",
																			"Disabled",
																			"disabled",
																			"Enabled",
																			"enabled",
																		]
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

																		// nullable: true
																		items: {
																			// Host
																			type: "object"
																			properties: {
																				name: {
																					type:        "string"
																					description: "optional, by default replica name is generated, but you can override it and setup custom name"
																					minLength:   1
																					// See namePartReplicaMaxLen const
																					maxLength: 15
																					pattern:   "^[a-zA-Z0-9-]{0,15}$"
																				}
																				secure: {
																					type: "string"
																					description: """
		optional, setup `secure` inside `clickhouse-server` settings for each Pod where current template will apply
		if specified

		"""
																					enum: [
																						"",
																						"0",
																						"1",
																						"False",
																						"false",
																						"True",
																						"true",
																						"No",
																						"no",
																						"Yes",
																						"yes",
																						"Off",
																						"off",
																						"On",
																						"on",
																						"Disable",
																						"disable",
																						"Enable",
																						"enable",
																						"Disabled",
																						"disabled",
																						"Enabled",
																						"enabled",
																					]
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
																	}
																}
															}
														}

														replicas: {
															type:        "array"
															description: "optional, allows override top-level `chi.spec.configuration` and cluster-level `chi.spec.configuration.clusters` configuration for each replica and each shard relates to selected replica, use it only if you fully understand what you do"
															// nullable: true
															items: {
																type: "object"
																properties: {
																	name: {
																		type:        "string"
																		description: "optional, by default replica name is generated, but you can override it and setup custom name"
																		minLength:   1
																		// See namePartShardMaxLen const
																		maxLength: 15
																		pattern:   "^[a-zA-Z0-9-]{0,15}$"
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

																	shardsCount: {
																		type:        "integer"
																		description: "optional, count of shards related to current replica, you can override each shard behavior on low-level `chi.spec.configuration.clusters.layout.replicas.shards`"
																		minimum:     1
																	}
																	shards: {
																		type:        "array"
																		description: "optional, list of shards related to current replica, will ignore if `chi.spec.configuration.clusters.layout.shards` presents"
																		// nullable: true
																		items: {
																			// Host
																			type: "object"
																			properties: {
																				name: {
																					type:        "string"
																					description: "optional, by default shard name is generated, but you can override it and setup custom name"
																					minLength:   1
																					// See namePartReplicaMaxLen const
																					maxLength: 15
																					pattern:   "^[a-zA-Z0-9-]{0,15}$"
																				}
																				secure: {
																					type: "string"
																					description: """
		optional, setup `secure` inside `clickhouse-server` settings for each Pod where current template will apply
		if specified

		"""
																					enum: [
																						"",
																						"0",
																						"1",
																						"False",
																						"false",
																						"True",
																						"true",
																						"No",
																						"no",
																						"Yes",
																						"yes",
																						"Off",
																						"off",
																						"On",
																						"on",
																						"Disable",
																						"disable",
																						"Enable",
																						"enable",
																						"Disabled",
																						"disabled",
																						"Enabled",
																						"enabled",
																					]
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
								// nullable: true
								properties: {
									hostTemplates: {
										type:        "array"
										description: "hostTemplate will use during apply to generate `clickhose-server` config files"
										// nullable: true
										items: {
											type: "object"
											//required:
											//  - name
											properties: {
												name: {
													description: "template name, could use to link inside top-level `chi.spec.defaults.templates.hostTemplate`, cluster-level `chi.spec.configuration.clusters.templates.hostTemplate`, shard-level `chi.spec.configuration.clusters.layout.shards.temlates.hostTemplate`, replica-level `chi.spec.configuration.clusters.layout.replicas.templates.hostTemplate`"
													type:        "string"
												}
												portDistribution: {
													type:        "array"
													description: "define how will distribute numeric values of named ports in `Pod.spec.containers.ports` and clickhouse-server configs"
													// nullable: true
													items: {
														type: "object"
														//required:
														//  - type
														properties: {
															type: {
																type:        "string"
																description: "type of distribution, when `Unspecified` (default value) then all listen ports on clickhouse-server configuration in all Pods will have the same value, when `ClusterScopeIndex` then ports will increment to offset from base value depends on shard and replica index inside cluster with combination of `chi.spec.templates.podTemlates.spec.HostNetwork` it allows setup ClickHouse cluster inside Kubernetes and provide access via external network bypass Kubernetes internal network"
																enum:
																// List PortDistributionXXX constants
																[
																	"",
																	"Unspecified",
																	"ClusterScopeIndex",
																]
															}
														}
													}
												}
												spec: {
													// Host
													type: "object"
													properties: {
														name: {
															type:        "string"
															description: "by default, hostname will generate, but this allows define custom name for each `clickhuse-server`"
															minLength:   1
															// See namePartReplicaMaxLen const
															maxLength: 15
															pattern:   "^[a-zA-Z0-9-]{0,15}$"
														}
														secure: {
															type: "string"
															description: """
		optional, setup `secure` inside `clickhouse-server` settings for each Pod where current template will apply
		if specified

		"""
															enum: [
																"",
																"0",
																"1",
																"False",
																"false",
																"True",
																"true",
																"No",
																"no",
																"Yes",
																"yes",
																"Off",
																"off",
																"On",
																"on",
																"Disable",
																"disable",
																"Enable",
																"enable",
																"Disabled",
																"disabled",
																"Enabled",
																"enabled",
															]
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
															description: "be careful, this part of CRD allows override template inside template, don't use it if you don't understand what you do"
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
											}
										}
									}

									podTemplates: {
										type: "array"
										description: """
		podTemplate will use during render `Pod` inside `StatefulSet.spec` and allows define rendered `Pod.spec`, pod scheduling distribution and pod zone
		More information: https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#spectemplatespodtemplates

		"""

										// nullable: true
										items: {
											type: "object"
											//required:
											//  - name
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
													//required:
													//  - values
													properties: {
														key: {
															type:        "string"
															description: "optional, if defined, allows select kubernetes nodes by label with `name` equal `key`"
														}
														values: {
															type:        "array"
															description: "optional, if defined, allows select kubernetes nodes by label with `value` in `values`"
															// nullable: true
															items: {
																type: "string"
															}
														}
													}
												}
												distribution: {
													type:        "string"
													description: "DEPRECATED, shortcut for `chi.spec.templates.podTemplates.spec.affinity.podAntiAffinity`"
													enum: [
														"",
														"Unspecified",
														"OnePerHost",
													]
												}
												podDistribution: {
													type:        "array"
													description: "define ClickHouse Pod distribution policy between Kubernetes Nodes inside Shard, Replica, Namespace, CHI, another ClickHouse cluster"
													// nullable: true
													items: {
														type: "object"
														//required:
														//  - type
														properties: {
															type: {
																type:        "string"
																description: "you can define multiple affinity policy types"
																enum:
																// List PodDistributionXXX constants
																[
																	"",
																	"Unspecified",
																	"ClickHouseAntiAffinity",
																	"ShardAntiAffinity",
																	"ReplicaAntiAffinity",
																	"AnotherNamespaceAntiAffinity",
																	"AnotherClickHouseInstallationAntiAffinity",
																	"AnotherClusterAntiAffinity",
																	"MaxNumberPerNode",
																	"NamespaceAffinity",
																	"ClickHouseInstallationAffinity",
																	"ClusterAffinity",
																	"ShardAffinity",
																	"ReplicaAffinity",
																	"PreviousTailAffinity",
																	"CircularReplication",
																]
															}
															scope: {
																type:        "string"
																description: "scope for apply each podDistribution"
																enum:
																// list PodDistributionScopeXXX constants
																[
																	"",
																	"Unspecified",
																	"Shard",
																	"Replica",
																	"Cluster",
																	"ClickHouseInstallation",
																	"Namespace",
																]
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
													// TODO specify PodSpec
													type:        "object"
													description: "allows define whole Pod.spec inside StaefulSet.spec, look to https://kubernetes.io/docs/concepts/workloads/pods/#pod-templates for details"
													// nullable: true
													"x-kubernetes-preserve-unknown-fields": true
												}
												metadata: {
													type: "object"
													description: """
		allows pass standard object's metadata from template to Pod
		More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

		"""

													// nullable: true
													"x-kubernetes-preserve-unknown-fields": true
												}
											}
										}
									}

									volumeClaimTemplates: {
										type:        "array"
										description: "allows define template for rendering `PVC` kubernetes resource, which would use inside `Pod` for mount clickhouse `data`, clickhouse `logs` or something else"
										// nullable: true
										items: {
											type: "object"
											//required:
											//  - name
											//  - spec
											properties: {
												name: {
													type: "string"
													description: """
		template name, could use to link inside
		top-level `chi.spec.defaults.templates.dataVolumeClaimTemplate` or `chi.spec.defaults.templates.logVolumeClaimTemplate`,
		cluster-level `chi.spec.configuration.clusters.templates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.templates.logVolumeClaimTemplate`,
		shard-level `chi.spec.configuration.clusters.layout.shards.temlates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.layout.shards.temlates.logVolumeClaimTemplate`
		replica-level `chi.spec.configuration.clusters.layout.replicas.templates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.layout.replicas.templates.logVolumeClaimTemplate`

		"""
												}

												provisioner: {
													type:        "string"
													description: "defines `PVC` provisioner - be it StatefulSet or the Operator"
													enum: [
														"",
														"StatefulSet",
														"Operator",
													]
												}

												reclaimPolicy: {
													type: "string"
													description: """
		defines behavior of `PVC` deletion.
		`Delete` by default, if `Retain` specified then `PVC` will be kept when deleting StatefulSet

		"""
													enum: [
														"",
														"Retain",
														"Delete",
													]
												}

												metadata: {
													type: "object"
													description: """
		allows to pass standard object's metadata from template to PVC
		More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

		"""

													// nullable: true
													"x-kubernetes-preserve-unknown-fields": true
												}
												spec: {
													type: "object"
													description: """
		allows define all aspects of `PVC` resource
		More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims

		"""

													// nullable: true
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

										// nullable: true
										items: {
											type: "object"
											//required:
											//  - name
											//  - spec
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
													// TODO specify ObjectMeta
													type: "object"
													description: """
		allows pass standard object's metadata from template to Service
		Could be use for define specificly for Cloud Provider metadata which impact to behavior of service
		More info: https://kubernetes.io/docs/concepts/services-networking/service/

		"""

													// nullable: true
													"x-kubernetes-preserve-unknown-fields": true
												}
												spec: {
													// TODO specify ServiceSpec
													type: "object"
													description: """
		describe behavior of generated Service
		More info: https://kubernetes.io/docs/concepts/services-networking/service/

		"""

													// nullable: true
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
								// nullable: true
								items: {
									type: "object"
									//required:
									//  - name
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
											enum:
											// List useTypeXXX constants from model
											[
												"",
												"merge",
											]
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
CustomResourceDefinition: "clickhouseinstallationtemplates.clickhouse.altinity.com": {
	// Template Parameters:
	//
	// KIND=ClickHouseInstallationTemplate
	// SINGULAR=clickhouseinstallationtemplate
	// PLURAL=clickhouseinstallationtemplates
	// SHORT=chit
	//
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		name: "clickhouseinstallationtemplates.clickhouse.altinity.com"
		labels: "clickhouse.altinity.com/chop": "0.20.3"
	}
	spec: {
		group: "clickhouse.altinity.com"
		scope: "Namespaced"
		names: {
			kind:     "ClickHouseInstallationTemplate"
			singular: "clickhouseinstallationtemplate"
			plural:   "clickhouseinstallationtemplates"
			shortNames: [
				"chit",
			]
		}
		versions: [{
			name:    "v1"
			served:  true
			storage: true
			additionalPrinterColumns: [{
				name:        "version"
				type:        "string"
				description: "Operator version"
				priority:    1 // show in wide view
				jsonPath:    ".status.chop-version"
			}, {
				name:        "clusters"
				type:        "integer"
				description: "Clusters count"
				priority:    0 // show in standard view
				jsonPath:    ".status.clusters"
			}, {
				name:        "shards"
				type:        "integer"
				description: "Shards count"
				priority:    1 // show in wide view
				jsonPath:    ".status.shards"
			}, {
				name:        "hosts"
				type:        "integer"
				description: "Hosts count"
				priority:    0 // show in standard view
				jsonPath:    ".status.hosts"
			}, {
				name:        "taskID"
				type:        "string"
				description: "TaskID"
				priority:    1 // show in wide view
				jsonPath:    ".status.taskID"
			}, {
				name:        "status"
				type:        "string"
				description: "CHI status"
				priority:    0 // show in standard view
				jsonPath:    ".status.status"
			}, {
				name:        "hosts-updated"
				type:        "integer"
				description: "Updated hosts count"
				priority:    1 // show in wide view
				jsonPath:    ".status.hostsUpdated"
			}, {
				name:        "hosts-added"
				type:        "integer"
				description: "Added hosts count"
				priority:    1 // show in wide view
				jsonPath:    ".status.hostsAdded"
			}, {
				name:        "hosts-completed"
				type:        "integer"
				description: "Completed hosts count"
				priority:    0 // show in standard view
				jsonPath:    ".status.hostsCompleted"
			}, {
				name:        "hosts-deleted"
				type:        "integer"
				description: "Hosts deleted count"
				priority:    1 // show in wide view
				jsonPath:    ".status.hostsDeleted"
			}, {
				name:        "hosts-delete"
				type:        "integer"
				description: "Hosts to be deleted count"
				priority:    1 // show in wide view
				jsonPath:    ".status.hostsDelete"
			}, {
				name:        "endpoint"
				type:        "string"
				description: "Client access endpoint"
				priority:    1 // show in wide view
				jsonPath:    ".status.endpoint"
			}, {
				name:        "age"
				type:        "date"
				description: "Age of the resource"
				// Displayed in all priorities
				jsonPath: ".metadata.creationTimestamp"
			}]
			subresources: status: {}
			schema: openAPIV3Schema: {
				description: "define a set of Kubernetes resources (StatefulSet, PVC, Service, ConfigMap) which describe behavior one or more ClickHouse clusters"
				type:        "object"
				required: [
					"spec",
				]
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					status: {
						type:        "object"
						description: "Current ClickHouseInstallation manifest status, contains many fields like a normalized configuration, clickhouse-operator version, current action and all applied action list, current taskID and all applied taskIDs and other"
						properties: {
							"chop-version": {
								type:        "string"
								description: "ClickHouse operator version"
							}
							"chop-commit": {
								type:        "string"
								description: "ClickHouse operator git commit SHA"
							}
							"chop-date": {
								type:        "string"
								description: "ClickHouse operator build date"
							}
							"chop-ip": {
								type:        "string"
								description: "IP address of the operator's pod which managed this CHI"
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
							hostsUpdated: {
								type:        "integer"
								minimum:     0
								description: "Updated Hosts count"
							}
							hostsAdded: {
								type:        "integer"
								minimum:     0
								description: "Added Hosts count"
							}
							hostsCompleted: {
								type:        "integer"
								minimum:     0
								description: "Completed Hosts count"
							}
							hostsDeleted: {
								type:        "integer"
								minimum:     0
								description: "Deleted Hosts count"
							}
							hostsDelete: {
								type:        "integer"
								minimum:     0
								description: "About to delete Hosts count"
							}
							pods: {
								type:        "array"
								description: "Pods"
								items: type: "string"
							}
							"pod-ips": {
								type:        "array"
								description: "Pod IPs"
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
								description:                            "Normalized CHI requested"
								"x-kubernetes-preserve-unknown-fields": true
							}
							normalizedCompleted: {
								type:                                   "object"
								description:                            "Normalized CHI completed"
								"x-kubernetes-preserve-unknown-fields": true
							}
						}
					}
					spec: {
						type: "object"
						// x-kubernetes-preserve-unknown-fields: true
						description: """
		Specification of the desired behavior of one or more ClickHouse clusters
		More info: https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md

		"""

						properties: {
							taskID: {
								type: "string"
								description: """
		Allows to define custom taskID for named update operation and watch status of this update execution in .status.taskIDs field.
		By default every update of chi manifest will generate random taskID

		"""
							}

							stop: {
								type: "string"
								description: """
		Allow stop all ClickHouse clusters described in current chi.
		Stop mechanism works as follows:
		 - When `stop` is `1` then setup `Replicas: 0` in each related to current `chi` StatefulSet resource, all `Pods` and `Service` resources will desctroy, but PVCs still live
		 - When `stop` is `0` then `Pods` will created again and will attach retained PVCs and `Service` also will created again

		"""

								enum:
								// List StringBoolXXX constants from model
								[
									"",
									"0",
									"1",
									"False",
									"false",
									"True",
									"true",
									"No",
									"no",
									"Yes",
									"yes",
									"Off",
									"off",
									"On",
									"on",
									"Disable",
									"disable",
									"Enable",
									"enable",
									"Disabled",
									"disabled",
									"Enabled",
									"enabled",
								]
							}
							restart: {
								type:        "string"
								description: "This is a 'soft restart' button. When set to 'RollingUpdate' operator will restart ClickHouse pods in a graceful way. Remove it after the use in order to avoid unneeded restarts"
								enum: [
									"",
									"RollingUpdate",
								]
							}
							troubleshoot: {
								type:        "string"
								description: "allows troubleshoot Pods during CrashLoopBack state, when you apply wrong configuration, `clickhouse-server` wouldn't startup"
								enum: [
									"",
									"0",
									"1",
									"False",
									"false",
									"True",
									"true",
									"No",
									"no",
									"Yes",
									"yes",
									"Off",
									"off",
									"On",
									"on",
									"Disable",
									"disable",
									"Enable",
									"enable",
									"Disabled",
									"disabled",
									"Enabled",
									"enabled",
								]
							}
							namespaceDomainPattern: {
								type:        "string"
								description: "custom domain suffix which will add to end of `Service` or `Pod` name, use it when you use custom cluster domain in your Kubernetes cluster"
							}
							templating: {
								type: "object"
								// nullable: true
								description: "optional, define policy for auto applying ClickHouseInstallationTemplate inside ClickHouseInstallation"
								properties: policy: {
									type:        "string"
									description: "when defined as `auto` inside ClickhouseInstallationTemplate, it will auto add into all ClickHouseInstallation, manual value is default"
									enum: [
										"auto",
										"manual",
									]
								}
							}
							reconciling: {
								type:        "object"
								description: "optional, allows tuning reconciling cycle for ClickhouseInstallation from clickhouse-operator side"
								// nullable: true
								properties: {
									policy: {
										type:        "string"
										description: "DEPRECATED"
									}
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
										// nullable: true
										properties: {
											unknownObjects: {
												type:        "object"
												description: "what clickhouse-operator shall do when found Kubernetes resources which should be managed with clickhouse-operator, but not have `ownerReference` to any currently managed `ClickHouseInstallation` resource, default behavior is `Delete`"
												// nullable: true
												properties: {
													statefulSet: {
														type:        "string"
														description: "behavior policy for unknown StatefulSet, Delete by default"
														enum:
														// List ObjectsCleanupXXX constants from model
														[
															"Retain",
															"Delete",
														]
													}
													pvc: {
														type:        "string"
														description: "behavior policy for unknown PVC, Delete by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
													configMap: {
														type:        "string"
														description: "behavior policy for unknown ConfigMap, Delete by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
													service: {
														type:        "string"
														description: "behavior policy for unknown Service, Delete by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
												}
											}
											reconcileFailedObjects: {
												type:        "object"
												description: "what clickhouse-operator shall do when reconciling Kubernetes resources are failed, default behavior is `Retain`"
												// nullable: true
												properties: {
													statefulSet: {
														type:        "string"
														description: "behavior policy for failed StatefulSet reconciling, Retain by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
													pvc: {
														type:        "string"
														description: "behavior policy for failed PVC reconciling, Retain by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
													configMap: {
														type:        "string"
														description: "behavior policy for failed ConfigMap reconciling, Retain by default"
														enum: [
															"Retain",
															"Delete",
														]
													}
													service: {
														type:        "string"
														description: "behavior policy for failed Service reconciling, Retain by default"
														enum: [
															"Retain",
															"Delete",
														]
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

								// nullable: true
								properties: {
									replicasUseFQDN: {
										type: "string"
										description: """
		define should replicas be specified by FQDN in `<host></host>`.
		In case of \"no\" will use short hostname and clickhouse-server will use kubernetes default suffixes for DNS lookup
		\"yes\" by default

		"""
										enum: [
											"",
											"0",
											"1",
											"False",
											"false",
											"True",
											"true",
											"No",
											"no",
											"Yes",
											"yes",
											"Off",
											"off",
											"On",
											"on",
											"Disable",
											"disable",
											"Enable",
											"enable",
											"Disabled",
											"disabled",
											"Enabled",
											"enabled",
										]
									}

									distributedDDL: {
										type: "object"
										description: """
		allows change `<yandex><distributed_ddl></distributed_ddl></yandex>` settings
		More info: https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#server-settings-distributed_ddl

		"""

										// nullable: true
										properties: {
											profile: {
												type:        "string"
												description: "Settings from this profile will be used to execute DDL queries"
											}
										}
									}
									storageManagement: {
										type:        "object"
										description: "default storage management options"
										properties: {
											provisioner: {
												type:        "string"
												description: "defines `PVC` provisioner - be it StatefulSet or the Operator"
												enum: [
													"",
													"StatefulSet",
													"Operator",
												]
											}
											reclaimPolicy: {
												type: "string"
												description: """
		defines behavior of `PVC` deletion.
		`Delete` by default, if `Retain` specified then `PVC` will be kept when deleting StatefulSet

		"""

												enum: [
													"",
													"Retain",
													"Delete",
												]
											}
										}
									}
									templates: {
										type:        "object"
										description: "optional, configuration of the templates names which will use for generate Kubernetes resources according to one or more ClickHouse clusters described in current ClickHouseInstallation (chi) resource"
										// nullable: true
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
								// nullable: true
								properties: {
									zookeeper: {
										type: "object"
										description: """
		allows configure <yandex><zookeeper>..</zookeeper></yandex> section in each `Pod` during generate `ConfigMap` which will mounted in `/etc/clickhouse-server/config.d/`
		`clickhouse-operator` itself doesn't manage Zookeeper, please install Zookeeper separatelly look examples on https://github.com/Altinity/clickhouse-operator/tree/master/deploy/zookeeper/
		currently, zookeeper (or clickhouse-keeper replacement) used for *ReplicatedMergeTree table engines and for `distributed_ddl`
		More details: https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#server-settings_zookeeper

		"""

										// nullable: true
										properties: {
											nodes: {
												type:        "array"
												description: "describe every available zookeeper cluster node for interaction"
												// nullable: true
												items: {
													type: "object"
													//required:
													//  - host
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

										// nullable: true
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

										// nullable: true
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

										// nullable: true
										"x-kubernetes-preserve-unknown-fields": true
									}
									settings: {
										type: "object"
										description: """
		allows configure `clickhouse-server` settings inside <yandex>...</yandex> tag in each `Pod` during generate `ConfigMap` which will mount in `/etc/clickhouse-server/config.d/`
		More details: https://clickhouse.tech/docs/en/operations/settings/settings/
		Your yaml code will convert to XML, see examples https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#specconfigurationsettings

		"""

										// nullable: true
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

										// nullable: true
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

										// nullable: true
										items: {
											type: "object"
											//required:
											//  - name
											properties: {
												name: {
													type:        "string"
													description: "cluster name, used to identify set of ClickHouse servers and wide used during generate names of related Kubernetes resources"
													minLength:   1
													// See namePartClusterMaxLen const
													maxLength: 15
													pattern:   "^[a-zA-Z0-9-]{0,15}$"
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

												schemaPolicy: {
													type: "object"
													description: """
		describes how schema is propagated within replicas and shards

		"""

													properties: {
														replica: {
															type:        "string"
															description: "how schema is propagated within a replica"
															enum:
															// List SchemaPolicyReplicaXXX constants from model
															[
																"None",
																"All",
															]
														}
														shard: {
															type:        "string"
															description: "how schema is propagated between shards"
															enum:
															// List SchemaPolicyShardXXX constants from model
															[
																"None",
																"All",
																"DistributedTablesOnly",
															]
														}
													}
												}
												secure: {
													type:        "string"
													description: "optional, setup `secure` inside `clickhouse-server` settings for each Pod of the cluster"
													enum: [
														"",
														"0",
														"1",
														"False",
														"false",
														"True",
														"true",
														"No",
														"no",
														"Yes",
														"yes",
														"Off",
														"off",
														"On",
														"on",
														"Disable",
														"disable",
														"Enable",
														"enable",
														"Disabled",
														"disabled",
														"Enabled",
														"enabled",
													]
												}
												secret: {
													type:        "object"
													description: "optional, shared secret value to secure cluster communications"
													properties: {
														auto: {
															type:        "string"
															description: "Auto-generate shared secret value to secure cluster communications"
															enum: [
																"",
																"0",
																"1",
																"False",
																"false",
																"True",
																"true",
																"No",
																"no",
																"Yes",
																"yes",
																"Off",
																"off",
																"On",
																"on",
																"Disable",
																"disable",
																"Enable",
																"enable",
																"Disabled",
																"disabled",
																"Enabled",
																"enabled",
															]
														}
														value: {
															description: "Cluster shared secret value in plain text"
															type:        "string"
														}
														valueFrom: {
															description: "Cluster shared secret source"
															type:        "object"
															properties: secretKeyRef: {
																description: """
		Selects a key of a secret in the clickhouse installation namespace.
		Should not be used if value is not empty.

		"""

																type: "object"
																properties: {
																	name: {
																		description: """
		Name of the referent. More info:
		https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names

		"""

																		type: "string"
																	}
																	key: {
																		description: "The key of the secret to select from. Must be a valid secret key."
																		type:        "string"
																	}
																	optional: {
																		description: "Specify whether the Secret or its key must be defined"
																		type:        "boolean"
																	}
																}
																required: [
																	"name",
																	"key",
																]
															}
														}
													}
												}
												layout: {
													type: "object"
													description: """
		describe current cluster layout, how much shards in cluster, how much replica in shard
		allows override settings on each shard and replica separatelly

		"""

													// nullable: true
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
															// nullable: true
															items: {
																type: "object"
																properties: {
																	name: {
																		type:        "string"
																		description: "optional, by default shard name is generated, but you can override it and setup custom name"
																		minLength:   1
																		// See namePartShardMaxLen const
																		maxLength: 15
																		pattern:   "^[a-zA-Z0-9-]{0,15}$"
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
																		enum: [
																			"",
																			"0",
																			"1",
																			"False",
																			"false",
																			"True",
																			"true",
																			"No",
																			"no",
																			"Yes",
																			"yes",
																			"Off",
																			"off",
																			"On",
																			"on",
																			"Disable",
																			"disable",
																			"Enable",
																			"enable",
																			"Disabled",
																			"disabled",
																			"Enabled",
																			"enabled",
																		]
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

																		// nullable: true
																		items: {
																			// Host
																			type: "object"
																			properties: {
																				name: {
																					type:        "string"
																					description: "optional, by default replica name is generated, but you can override it and setup custom name"
																					minLength:   1
																					// See namePartReplicaMaxLen const
																					maxLength: 15
																					pattern:   "^[a-zA-Z0-9-]{0,15}$"
																				}
																				secure: {
																					type: "string"
																					description: """
		optional, setup `secure` inside `clickhouse-server` settings for each Pod where current template will apply
		if specified

		"""
																					enum: [
																						"",
																						"0",
																						"1",
																						"False",
																						"false",
																						"True",
																						"true",
																						"No",
																						"no",
																						"Yes",
																						"yes",
																						"Off",
																						"off",
																						"On",
																						"on",
																						"Disable",
																						"disable",
																						"Enable",
																						"enable",
																						"Disabled",
																						"disabled",
																						"Enabled",
																						"enabled",
																					]
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
																	}
																}
															}
														}

														replicas: {
															type:        "array"
															description: "optional, allows override top-level `chi.spec.configuration` and cluster-level `chi.spec.configuration.clusters` configuration for each replica and each shard relates to selected replica, use it only if you fully understand what you do"
															// nullable: true
															items: {
																type: "object"
																properties: {
																	name: {
																		type:        "string"
																		description: "optional, by default replica name is generated, but you can override it and setup custom name"
																		minLength:   1
																		// See namePartShardMaxLen const
																		maxLength: 15
																		pattern:   "^[a-zA-Z0-9-]{0,15}$"
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

																	shardsCount: {
																		type:        "integer"
																		description: "optional, count of shards related to current replica, you can override each shard behavior on low-level `chi.spec.configuration.clusters.layout.replicas.shards`"
																		minimum:     1
																	}
																	shards: {
																		type:        "array"
																		description: "optional, list of shards related to current replica, will ignore if `chi.spec.configuration.clusters.layout.shards` presents"
																		// nullable: true
																		items: {
																			// Host
																			type: "object"
																			properties: {
																				name: {
																					type:        "string"
																					description: "optional, by default shard name is generated, but you can override it and setup custom name"
																					minLength:   1
																					// See namePartReplicaMaxLen const
																					maxLength: 15
																					pattern:   "^[a-zA-Z0-9-]{0,15}$"
																				}
																				secure: {
																					type: "string"
																					description: """
		optional, setup `secure` inside `clickhouse-server` settings for each Pod where current template will apply
		if specified

		"""
																					enum: [
																						"",
																						"0",
																						"1",
																						"False",
																						"false",
																						"True",
																						"true",
																						"No",
																						"no",
																						"Yes",
																						"yes",
																						"Off",
																						"off",
																						"On",
																						"on",
																						"Disable",
																						"disable",
																						"Enable",
																						"enable",
																						"Disabled",
																						"disabled",
																						"Enabled",
																						"enabled",
																					]
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
								// nullable: true
								properties: {
									hostTemplates: {
										type:        "array"
										description: "hostTemplate will use during apply to generate `clickhose-server` config files"
										// nullable: true
										items: {
											type: "object"
											//required:
											//  - name
											properties: {
												name: {
													description: "template name, could use to link inside top-level `chi.spec.defaults.templates.hostTemplate`, cluster-level `chi.spec.configuration.clusters.templates.hostTemplate`, shard-level `chi.spec.configuration.clusters.layout.shards.temlates.hostTemplate`, replica-level `chi.spec.configuration.clusters.layout.replicas.templates.hostTemplate`"
													type:        "string"
												}
												portDistribution: {
													type:        "array"
													description: "define how will distribute numeric values of named ports in `Pod.spec.containers.ports` and clickhouse-server configs"
													// nullable: true
													items: {
														type: "object"
														//required:
														//  - type
														properties: {
															type: {
																type:        "string"
																description: "type of distribution, when `Unspecified` (default value) then all listen ports on clickhouse-server configuration in all Pods will have the same value, when `ClusterScopeIndex` then ports will increment to offset from base value depends on shard and replica index inside cluster with combination of `chi.spec.templates.podTemlates.spec.HostNetwork` it allows setup ClickHouse cluster inside Kubernetes and provide access via external network bypass Kubernetes internal network"
																enum:
																// List PortDistributionXXX constants
																[
																	"",
																	"Unspecified",
																	"ClusterScopeIndex",
																]
															}
														}
													}
												}
												spec: {
													// Host
													type: "object"
													properties: {
														name: {
															type:        "string"
															description: "by default, hostname will generate, but this allows define custom name for each `clickhuse-server`"
															minLength:   1
															// See namePartReplicaMaxLen const
															maxLength: 15
															pattern:   "^[a-zA-Z0-9-]{0,15}$"
														}
														secure: {
															type: "string"
															description: """
		optional, setup `secure` inside `clickhouse-server` settings for each Pod where current template will apply
		if specified

		"""
															enum: [
																"",
																"0",
																"1",
																"False",
																"false",
																"True",
																"true",
																"No",
																"no",
																"Yes",
																"yes",
																"Off",
																"off",
																"On",
																"on",
																"Disable",
																"disable",
																"Enable",
																"enable",
																"Disabled",
																"disabled",
																"Enabled",
																"enabled",
															]
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
															description: "be careful, this part of CRD allows override template inside template, don't use it if you don't understand what you do"
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
											}
										}
									}

									podTemplates: {
										type: "array"
										description: """
		podTemplate will use during render `Pod` inside `StatefulSet.spec` and allows define rendered `Pod.spec`, pod scheduling distribution and pod zone
		More information: https://github.com/Altinity/clickhouse-operator/blob/master/docs/custom_resource_explained.md#spectemplatespodtemplates

		"""

										// nullable: true
										items: {
											type: "object"
											//required:
											//  - name
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
													//required:
													//  - values
													properties: {
														key: {
															type:        "string"
															description: "optional, if defined, allows select kubernetes nodes by label with `name` equal `key`"
														}
														values: {
															type:        "array"
															description: "optional, if defined, allows select kubernetes nodes by label with `value` in `values`"
															// nullable: true
															items: {
																type: "string"
															}
														}
													}
												}
												distribution: {
													type:        "string"
													description: "DEPRECATED, shortcut for `chi.spec.templates.podTemplates.spec.affinity.podAntiAffinity`"
													enum: [
														"",
														"Unspecified",
														"OnePerHost",
													]
												}
												podDistribution: {
													type:        "array"
													description: "define ClickHouse Pod distribution policy between Kubernetes Nodes inside Shard, Replica, Namespace, CHI, another ClickHouse cluster"
													// nullable: true
													items: {
														type: "object"
														//required:
														//  - type
														properties: {
															type: {
																type:        "string"
																description: "you can define multiple affinity policy types"
																enum:
																// List PodDistributionXXX constants
																[
																	"",
																	"Unspecified",
																	"ClickHouseAntiAffinity",
																	"ShardAntiAffinity",
																	"ReplicaAntiAffinity",
																	"AnotherNamespaceAntiAffinity",
																	"AnotherClickHouseInstallationAntiAffinity",
																	"AnotherClusterAntiAffinity",
																	"MaxNumberPerNode",
																	"NamespaceAffinity",
																	"ClickHouseInstallationAffinity",
																	"ClusterAffinity",
																	"ShardAffinity",
																	"ReplicaAffinity",
																	"PreviousTailAffinity",
																	"CircularReplication",
																]
															}
															scope: {
																type:        "string"
																description: "scope for apply each podDistribution"
																enum:
																// list PodDistributionScopeXXX constants
																[
																	"",
																	"Unspecified",
																	"Shard",
																	"Replica",
																	"Cluster",
																	"ClickHouseInstallation",
																	"Namespace",
																]
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
													// TODO specify PodSpec
													type:        "object"
													description: "allows define whole Pod.spec inside StaefulSet.spec, look to https://kubernetes.io/docs/concepts/workloads/pods/#pod-templates for details"
													// nullable: true
													"x-kubernetes-preserve-unknown-fields": true
												}
												metadata: {
													type: "object"
													description: """
		allows pass standard object's metadata from template to Pod
		More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

		"""

													// nullable: true
													"x-kubernetes-preserve-unknown-fields": true
												}
											}
										}
									}

									volumeClaimTemplates: {
										type:        "array"
										description: "allows define template for rendering `PVC` kubernetes resource, which would use inside `Pod` for mount clickhouse `data`, clickhouse `logs` or something else"
										// nullable: true
										items: {
											type: "object"
											//required:
											//  - name
											//  - spec
											properties: {
												name: {
													type: "string"
													description: """
		template name, could use to link inside
		top-level `chi.spec.defaults.templates.dataVolumeClaimTemplate` or `chi.spec.defaults.templates.logVolumeClaimTemplate`,
		cluster-level `chi.spec.configuration.clusters.templates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.templates.logVolumeClaimTemplate`,
		shard-level `chi.spec.configuration.clusters.layout.shards.temlates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.layout.shards.temlates.logVolumeClaimTemplate`
		replica-level `chi.spec.configuration.clusters.layout.replicas.templates.dataVolumeClaimTemplate` or `chi.spec.configuration.clusters.layout.replicas.templates.logVolumeClaimTemplate`

		"""
												}

												provisioner: {
													type:        "string"
													description: "defines `PVC` provisioner - be it StatefulSet or the Operator"
													enum: [
														"",
														"StatefulSet",
														"Operator",
													]
												}

												reclaimPolicy: {
													type: "string"
													description: """
		defines behavior of `PVC` deletion.
		`Delete` by default, if `Retain` specified then `PVC` will be kept when deleting StatefulSet

		"""
													enum: [
														"",
														"Retain",
														"Delete",
													]
												}

												metadata: {
													type: "object"
													description: """
		allows to pass standard object's metadata from template to PVC
		More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

		"""

													// nullable: true
													"x-kubernetes-preserve-unknown-fields": true
												}
												spec: {
													type: "object"
													description: """
		allows define all aspects of `PVC` resource
		More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims

		"""

													// nullable: true
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

										// nullable: true
										items: {
											type: "object"
											//required:
											//  - name
											//  - spec
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
													// TODO specify ObjectMeta
													type: "object"
													description: """
		allows pass standard object's metadata from template to Service
		Could be use for define specificly for Cloud Provider metadata which impact to behavior of service
		More info: https://kubernetes.io/docs/concepts/services-networking/service/

		"""

													// nullable: true
													"x-kubernetes-preserve-unknown-fields": true
												}
												spec: {
													// TODO specify ServiceSpec
													type: "object"
													description: """
		describe behavior of generated Service
		More info: https://kubernetes.io/docs/concepts/services-networking/service/

		"""

													// nullable: true
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
								// nullable: true
								items: {
									type: "object"
									//required:
									//  - name
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
											enum:
											// List useTypeXXX constants from model
											[
												"",
												"merge",
											]
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
CustomResourceDefinition: "clickhouseoperatorconfigurations.clickhouse.altinity.com": {
	// Template Parameters:
	//
	// NONE
	//
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		name: "clickhouseoperatorconfigurations.clickhouse.altinity.com"
		labels: "clickhouse.altinity.com/chop": "0.20.3"
	}
	spec: {
		group: "clickhouse.altinity.com"
		scope: "Namespaced"
		names: {
			kind:     "ClickHouseOperatorConfiguration"
			singular: "clickhouseoperatorconfiguration"
			plural:   "clickhouseoperatorconfigurations"
			shortNames: [
				"chopconf",
			]
		}
		versions: [{
			name:    "v1"
			served:  true
			storage: true
			additionalPrinterColumns: [{
				name:        "namespaces"
				type:        "string"
				description: "Watch namespaces"
				priority:    0 // show in standard view
				jsonPath:    ".status"
			}, {
				name:        "age"
				type:        "date"
				description: "Age of the resource"
				// Displayed in all priorities
				jsonPath: ".metadata.creationTimestamp"
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
		Allows to define settings of the clickhouse-operator.
		More info: https://github.com/Altinity/clickhouse-operator/blob/master/config/config.yaml
		Check into etc-clickhouse-operator* ConfigMaps if you need more control

		"""

						"x-kubernetes-preserve-unknown-fields": true
						properties: {
							watch: {
								type:        "object"
								description: "Parameters for watch kubernetes resources which used by clickhouse-operator deployment"
								properties: namespaces: {
									type:        "array"
									description: "List of namespaces where clickhouse-operator watches for events."
									items: type: "string"
								}
							}
							clickhouse: {
								type:        "object"
								description: "Clickhouse related parameters used by clickhouse-operator"
								properties: {
									configuration: {
										type: "object"
										properties: {
											file: {
												type: "object"
												properties: path: {
													type: "object"
													properties: {
														common: {
															type:        "string"
															description: "Path to the folder where ClickHouse configuration files common for all instances within a CHI are located. Default - config.d"
														}
														host: {
															type:        "string"
															description: "Path to the folder where ClickHouse configuration files unique for each instance (host) within a CHI are located. Default - conf.d"
														}
														user: {
															type:        "string"
															description: "Path to the folder where ClickHouse configuration files with users settings are located. Files are common for all instances within a CHI. Default - users.d"
														}
													}
												}
											}
											user: {
												type:        "object"
												description: "Default parameters for any user which will create"
												properties: default: {
													type: "object"
													properties: {
														profile: {
															type:        "string"
															description: "ClickHouse server configuration `<profile>...</profile>` for any <user>"
														}
														quota: {
															type:        "string"
															description: "ClickHouse server configuration `<quota>...</quota>` for any <user>"
														}
														networksIP: {
															type:        "array"
															description: "ClickHouse server configuration `<networks><ip>...</ip></networks>` for any <user>"
															items: type: "string"
														}
														password: {
															type:        "string"
															description: "ClickHouse server configuration `<password>...</password>` for any <user>"
														}
													}
												}
											}
											network: {
												type:        "object"
												description: "Default network parameters for any user which will create"
												properties: hostRegexpTemplate: {
													type:        "string"
													description: "ClickHouse server configuration `<host_regexp>...</host_regexp>` for any <user>"
												}
											}
										}
									}
									access: {
										type:        "object"
										description: "parameters which use for connect to clickhouse from clickhouse-operator deployment"
										properties: {
											scheme: {
												type:        "string"
												description: "The scheme to user for connecting to ClickHouse. One of http or https"
											}
											username: {
												type:        "string"
												description: "ClickHouse username to be used by operator to connect to ClickHouse instances, deprecated, use chCredentialsSecretName"
											}
											password: {
												type:        "string"
												description: "ClickHouse password to be used by operator to connect to ClickHouse instances, deprecated, use chCredentialsSecretName"
											}
											rootCA: {
												type:        "string"
												description: "Root certificate authority that clients use when verifying server certificates. Used for https connection to ClickHouse"
											}
											secret: {
												type: "object"
												properties: {
													namespace: {
														type:        "string"
														description: "Location of k8s Secret with username and password to be used by operator to connect to ClickHouse instances"
													}
													name: {
														type:        "string"
														description: "Name of k8s Secret with username and password to be used by operator to connect to ClickHouse instances"
													}
												}
											}
											port: {
												type:        "integer"
												minimum:     1
												maximum:     65535
												description: "Port to be used by operator to connect to ClickHouse instances"
											}
											timeouts: {
												type:        "object"
												description: "Timeouts used to limit connection and queries from the operator to ClickHouse instances, In seconds"
												properties: {
													connect: {
														type:        "integer"
														minimum:     1
														maximum:     10
														description: "Connect timeout. In seconds."
													}
													query: {
														type:        "integer"
														minimum:     1
														maximum:     600
														description: "Query timeout. In seconds."
													}
												}
											}
										}
									}
									metrics: {
										type:        "object"
										description: "parameters which use for connect to fetch metrics from clickhouse by clickhouse-operator"
										properties: timeouts: {
											type:        "object"
											description: "Timeouts used to limit connection and queries from the operator to ClickHouse instances, In seconds"
											properties: collect: {
												type:        "integer"
												minimum:     1
												maximum:     600
												description: "Collect timeout. In seconds."
											}
										}
									}
								}
							}
							template: {
								type:        "object"
								description: "Parameters which are used if you want to generate ClickHouseInstallationTemplate custom resources from files which are stored inside clickhouse-operator deployment"
								properties: chi: {
									type: "object"
									properties: path: {
										type:        "string"
										description: "Path to folder where ClickHouseInstallationTemplate .yaml manifests are located."
									}
								}
							}
							reconcile: {
								type:        "object"
								description: "allow tuning reconciling process"
								properties: {
									runtime: {
										type:        "object"
										description: "runtime parameters for clickhouse-operator process which use during reconciling"
										properties: threadsNumber: {
											type:        "integer"
											minimum:     1
											maximum:     65535
											description: "How many goroutines will be used to reconcile in parallel, 10 by default"
										}
									}
									statefulSet: {
										type:        "object"
										description: "Allow change default behavior for reconciling StatefulSet which generated by clickhouse-operator"
										properties: {
											create: {
												type:        "object"
												description: "Behavior during create StatefulSet"
												properties: onFailure: {
													type: "string"
													description: """
		What to do in case created StatefulSet is not in Ready after `statefulSetUpdateTimeout` seconds
		Possible options:
		1. abort - do nothing, just break the process and wait for admin.
		2. delete - delete newly created problematic StatefulSet.
		3. ignore (default) - ignore error, pretend nothing happened and move on to the next StatefulSet.

		"""
												}
											}

											update: {
												type:        "object"
												description: "Behavior during update StatefulSet"
												properties: {
													timeout: {
														type:        "integer"
														description: "How many seconds to wait for created/updated StatefulSet to be Ready"
													}
													pollInterval: {
														type:        "integer"
														description: "How many seconds to wait between checks for created/updated StatefulSet status"
													}
													onFailure: {
														type: "string"
														description: """
		What to do in case updated StatefulSet is not in Ready after `statefulSetUpdateTimeout` seconds
		Possible options:
		1. abort - do nothing, just break the process and wait for admin.
		2. rollback (default) - delete Pod and rollback StatefulSet to previous Generation. Pod would be recreated by StatefulSet based on rollback-ed configuration.
		3. ignore - ignore error, pretend nothing happened and move on to the next StatefulSet.

		"""
													}
												}
											}
										}
									}

									host: {
										type:        "object"
										description: "allow define how to wait host include to system.cluster behavior during scale up and scale down cluster operations"
										properties: wait: {
											type: "object"
											properties: {
												exclude: {
													type:        "string"
													description: "wait when a pod will be removed from the cluster"
													enum:
													// List StringBoolXXX constants from model
													[
														"",
														"0",
														"1",
														"False",
														"false",
														"True",
														"true",
														"No",
														"no",
														"Yes",
														"yes",
														"Off",
														"off",
														"On",
														"on",
														"Disable",
														"disable",
														"Enable",
														"enable",
														"Disabled",
														"disabled",
														"Enabled",
														"enabled",
													]
												}
												include: {
													type:        "string"
													description: "wait when a pod will be added to the cluster"
													enum: [
														"",
														"0",
														"1",
														"False",
														"false",
														"True",
														"true",
														"No",
														"no",
														"Yes",
														"yes",
														"Off",
														"off",
														"On",
														"on",
														"Disable",
														"disable",
														"Enable",
														"enable",
														"Disabled",
														"disabled",
														"Enabled",
														"enabled",
													]
												}
											}
										}
									}
								}
							}
							annotation: {
								type:        "object"
								description: "defines which metadata.annotations items will include or exclude during render StatefulSet, Pod, PVC resources"
								properties: {
									include: {
										type: "array"
										description: """
		When propagating labels from the chi's `metadata.annotations` section to child objects' `metadata.annotations`,
		include annotations with names from the following list

		"""

										items: type: "string"
									}
									exclude: {
										type: "array"
										description: """
		When propagating labels from the chi's `metadata.annotations` section to child objects' `metadata.annotations`,
		exclude annotations with names from the following list

		"""

										items: type: "string"
									}
								}
							}
							label: {
								type:        "object"
								description: "defines which metadata.labels will include or exclude during render StatefulSet, Pod, PVC resources"
								properties: {
									include: {
										type: "array"
										description: """
		When propagating labels from the chi's `metadata.labels` section to child objects' `metadata.labels`,
		include labels from the following list

		"""

										items: type: "string"
									}
									exclude: {
										type: "array"
										items: type: "string"
										description: """
		When propagating labels from the chi's `metadata.labels` section to child objects' `metadata.labels`,
		exclude labels from the following list

		"""
									}

									appendScope: {
										type: "string"
										description: """
		Whether to append *Scope* labels to StatefulSet and Pod
		- \"LabelShardScopeIndex\"
		- \"LabelReplicaScopeIndex\"
		- \"LabelCHIScopeIndex\"
		- \"LabelCHIScopeCycleSize\"
		- \"LabelCHIScopeCycleIndex\"
		- \"LabelCHIScopeCycleOffset\"
		- \"LabelClusterScopeIndex\"
		- \"LabelClusterScopeCycleSize\"
		- \"LabelClusterScopeCycleIndex\"
		- \"LabelClusterScopeCycleOffset\"

		"""
										enum: [
											"",
											"0",
											"1",
											"False",
											"false",
											"True",
											"true",
											"No",
											"no",
											"Yes",
											"yes",
											"Off",
											"off",
											"On",
											"on",
											"Disable",
											"disable",
											"Enable",
											"enable",
											"Disabled",
											"disabled",
											"Enabled",
											"enabled",
										]
									}
								}
							}

							statefulSet: {
								type:        "object"
								description: "define StatefulSet-specific parameters"
								properties: revisionHistoryLimit: {
									type: "integer"
									description: """
		revisionHistoryLimit is the maximum number of revisions that will be
		maintained in the StatefulSet's revision history.                         
		Look details in `statefulset.spec.revisionHistoryLimit`

		"""
								}
							}

							pod: {
								type:        "object"
								description: "define pod specific parameters"
								properties: terminationGracePeriod: {
									type: "integer"
									description: """
		Optional duration in seconds the pod needs to terminate gracefully. 
		Look details in `pod.spec.terminationGracePeriodSeconds`

		"""
								}
							}

							logger: {
								type:        "object"
								description: "allow setup clickhouse-operator logger behavior"
								properties: {
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
									stderrthreshold: type: "string"
									vmodule: {
										type: "string"
										description: """
		Comma-separated list of filename=N, where filename (can be a pattern) must have no .go ext, and N is a V level.
		Ex.: file*=2 sets the 'V' to 2 in all files with names like file*.

		"""
									}

									log_backtrace_at: {
										type: "string"
										description: """
		It can be set to a file and line number with a logging line.
		Ex.: file.go:123
		Each time when this line is being executed, a stack trace will be written to the Info log.

		"""
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
ServiceAccount: "clickhouse-operator": {
	// Template Parameters:
	//
	// COMMENT=
	// NAMESPACE=default
	// NAME=clickhouse-operator
	//
	// Setup ServiceAccount
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "clickhouse-operator"
		namespace: "default"
		labels: "clickhouse.altinity.com/chop": "0.20.3"
	}
}
ClusterRole: "clickhouse-operator-default": {
	// Template Parameters:
	//
	// NAMESPACE=default
	// COMMENT=#
	// ROLE_KIND=ClusterRole
	// ROLE_NAME=clickhouse-operator-default
	// ROLE_BINDING_KIND=ClusterRoleBinding
	// ROLE_BINDING_NAME=clickhouse-operator-default
	//
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		name: "clickhouse-operator-default"
		//namespace: default
		labels: {
			"clickhouse.altinity.com/chop": "0.20.3"
		}
	}
	rules: [{
		apiGroups: [
			"",
		]
		resources: [
			"configmaps",
			"services",
			"persistentvolumeclaims",
			"secrets",
		]
		verbs: [
			"get",
			"list",
			"patch",
			"update",
			"watch",
			"create",
			"delete",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"endpoints",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"events",
		]
		verbs: [
			"create",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"persistentvolumes",
			"pods",
		]
		verbs: [
			"get",
			"list",
			"patch",
			"update",
			"watch",
		]
	}, {
		apiGroups: [
			"apps",
		]
		resources: [
			"statefulsets",
		]
		verbs: [
			"get",
			"list",
			"patch",
			"update",
			"watch",
			"create",
			"delete",
		]
	}, {
		apiGroups: [
			"apps",
		]
		resources: [
			"replicasets",
		]
		verbs: [
			"get",
			"patch",
			"update",
			"delete",
		]
	}, {
		apiGroups: [
			"apps",
		]
		resourceNames: [
			"clickhouse-operator",
		]
		resources: [
			"deployments",
		]
		verbs: [
			"get",
			"patch",
			"update",
			"delete",
		]
	}, {
		apiGroups: [
			"policy",
		]
		resources: [
			"poddisruptionbudgets",
		]
		verbs: [
			"get",
			"list",
			"patch",
			"update",
			"watch",
			"create",
			"delete",
		]
	}, {
		apiGroups: [
			"clickhouse.altinity.com",
		]
		resources: [
			"clickhouseinstallations",
		]
		verbs: [
			"get",
			"patch",
			"update",
			"delete",
		]
	}, {
		apiGroups: [
			"clickhouse.altinity.com",
		]
		resources: [
			"clickhouseinstallations",
			"clickhouseinstallationtemplates",
			"clickhouseoperatorconfigurations",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"clickhouse.altinity.com",
		]
		resources: [
			"clickhouseinstallations/finalizers",
			"clickhouseinstallationtemplates/finalizers",
			"clickhouseoperatorconfigurations/finalizers",
		]
		verbs: [
			"update",
		]
	}, {
		apiGroups: [
			"clickhouse.altinity.com",
		]
		resources: [
			"clickhouseinstallations/status",
			"clickhouseinstallationtemplates/status",
			"clickhouseoperatorconfigurations/status",
		]
		verbs: [
			"get",
			"update",
			"patch",
			"create",
			"delete",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"secrets",
		]
		verbs: [
			"get",
			"list",
		]
	}, {
		apiGroups: [
			"apiextensions.k8s.io",
		]
		resources: [
			"customresourcedefinitions",
		]
		verbs: [
			"get",
			"list",
		]
	}]
}
ClusterRoleBinding: "clickhouse-operator-default": {
	// Setup ClusterRoleBinding between ClusterRole and ServiceAccount.
	// ClusterRoleBinding is namespace-less and must have unique name
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		name: "clickhouse-operator-default"
		//namespace: default
		labels: {
			"clickhouse.altinity.com/chop": "0.20.3"
		}
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "clickhouse-operator-default"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "clickhouse-operator"
		namespace: "default"
	}]
}
ConfigMap: "etc-clickhouse-operator-files": {
	// Template Parameters:
	//
	// NAME=etc-clickhouse-operator-files
	// NAMESPACE=default
	// COMMENT=
	//
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "etc-clickhouse-operator-files"
		namespace: "default"
		labels: {
			"clickhouse.altinity.com/chop": "0.20.3"
			app:                            "clickhouse-operator"
		}
	}
	data: "config.yaml": """
		# IMPORTANT
		# This file is auto-generated
		# Do not edit this file - all changes would be lost
		# Edit appropriate template in the following folder:
		# deploy/builder/templates-config
		# IMPORTANT
		#
		# Template parameters available:
		#   WATCH_NAMESPACES=
		#   CH_USERNAME_PLAIN=
		#   CH_PASSWORD_PLAIN=
		#   CH_CREDENTIALS_SECRET_NAMESPACE=
		#   CH_CREDENTIALS_SECRET_NAME=clickhouse-operator

		################################################
		##
		## Watch Section
		##
		################################################
		watch:
		  # List of namespaces where clickhouse-operator watches for events.
		  # Concurrently running operators should watch on different namespaces.
		  #namespaces: [\"dev\", \"test\"]
		  namespaces: []

		clickhouse:
		  configuration:
		    ################################################
		    ##
		    ## Configuration Files Section
		    ##
		    ################################################
		    file:
		      path:
		        # Path to the folder where ClickHouse configuration files common for all instances within a CHI are located.
		        common: config.d
		        # Path to the folder where ClickHouse configuration files unique for each instance (host) within a CHI are located.
		        host: conf.d
		        # Path to the folder where ClickHouse configuration files with users' settings are located.
		        # Files are common for all instances within a CHI.
		        user: users.d
		    ################################################
		    ##
		    ## Configuration Users Section
		    ##
		    ################################################
		    user:
		      default:
		        # Default values for ClickHouse user configuration
		        # 1. user/profile - string
		        # 2. user/quota - string
		        # 3. user/networks/ip - multiple strings
		        # 4. user/password - string
		        profile: default
		        quota: default
		        networksIP:
		          - \"::1\"
		          - \"127.0.0.1\"
		        password: \"default\"
		    ################################################
		    ##
		    ## Configuration Network Section
		    ##
		    ################################################
		    network:
		      # Default host_regexp to limit network connectivity from outside
		      hostRegexpTemplate: \"(chi-{chi}-[^.]+\\\\d+-\\\\d+|clickhouse\\\\-{chi})\\\\.{namespace}\\\\.svc\\\\.cluster\\\\.local$\"
		  ################################################
		  ##
		  ## Access to ClickHouse instances
		  ##
		  ################################################
		  access:
		    # Possible values for `scheme` are:
		    # 1. http
		    # 2. https
		    scheme: \"\"
		    # ClickHouse credentials (username, password and port) to be used by the operator to connect to ClickHouse instances.
		    # Used for:
		    # 1. Metrics requests
		    # 2. Schema maintenance
		    # 3. DROP DNS CACHE
		    # User with these credentials can be specified in additional ClickHouse .xml config files,
		    # located in `clickhouse.configuration.file.path.user` folder
		    username: \"\"
		    password: \"\"
		    rootCA: \"\"

		    # Location of the k8s Secret with username and password to be used by the operator to connect to ClickHouse instances.
		    # Can be used instead of explicitly specified username and password which are:
		    # clickhouse.access.username
		    # clickhouse.access.password
		    # Secret should have two keys:
		    # 1. username
		    # 2. password
		    secret:
		      # Empty `namespace` means that k8s secret would be looked in the same namespace where operator's pod is running.
		      namespace: \"\"
		      # Empty `name` means no k8s Secret would be looked for
		      name: \"clickhouse-operator\"
		    # Port where to connect to ClickHouse instances to
		    port: 8123

		    # Timeouts used to limit connection and queries from the operator to ClickHouse instances
		    # Specified in seconds.
		    timeouts:
		      connect: 2
		      query: 5

		  metrics:
		    timeouts:
		      collect: 9

		################################################
		##
		## Templates Section
		##
		################################################
		template:
		  chi:
		    # Path to the folder where ClickHouseInstallation .yaml manifests are located.
		    # Manifests are applied in sorted alpha-numeric order.
		    path: templates.d

		################################################
		##
		## Reconcile Section
		##
		################################################
		reconcile:
		  runtime:
		    # Max number of concurrent reconciles in progress
		    threadsNumber: 10

		  statefulSet:
		    create:
		      # What to do in case created StatefulSet is not in 'Ready' after `reconcile.statefulSet.update.timeout` seconds
		      # Possible options:
		      # 1. abort - do nothing, just break the process and wait for an admin to assist
		      # 2. delete - delete newly created problematic StatefulSet
		      # 3. ignore - ignore an error, pretend nothing happened and move on to the next StatefulSet
		      onFailure: ignore

		    update:
		      # How many seconds to wait for created/updated StatefulSet to be 'Ready'
		      timeout: 300
		      # How many seconds to wait between checks/polls for created/updated StatefulSet status
		      pollInterval: 5
		      # What to do in case updated StatefulSet is not in 'Ready' after `reconcile.statefulSet.update.timeout` seconds
		      # Possible options:
		      # 1. abort - do nothing, just break the process and wait for an admin to assist
		      # 2. rollback - delete Pod and rollback StatefulSet to previous Generation.
		      # Pod would be recreated by StatefulSet based on rollback-ed configuration
		      # 3. ignore - ignore an error, pretend nothing happened and move on to the next StatefulSet
		      onFailure: rollback

		  host:
		    # Whether reconciler should wait for a host:
		    # - to be excluded from a cluster
		    # OR
		    # - to be included into a cluster
		    # respectfully
		    wait:
		      exclude: true
		      include: false

		################################################
		##
		## Annotations management
		##
		################################################
		annotation:
		  # Applied when:
		  #  1. Propagating annotations from the CHI's `metadata.annotations` to child objects' `metadata.annotations`,
		  #  2. Propagating annotations from the CHI Template's `metadata.annotations` to CHI's `metadata.annotations`,
		  # Include annotations from the following list:
		  # Applied only when not empty. Empty list means \"include all, no selection\"
		  include: []
		  # Exclude annotations from the following list:
		  exclude: []

		################################################
		##
		## Labels management
		##
		################################################
		label:
		  # Applied when:
		  #  1. Propagating labels from the CHI's `metadata.labels` to child objects' `metadata.labels`,
		  #  2. Propagating labels from the CHI Template's `metadata.labels` to CHI's `metadata.labels`,
		  # Include labels from the following list:
		  # Applied only when not empty. Empty list means \"include all, no selection\"
		  include: []
		  # Exclude labels from the following list:
		  # Applied only when not empty. Empty list means \"nothing to exclude, no selection\"
		  exclude: []
		  # Whether to append *Scope* labels to StatefulSet and Pod.
		  # Full list of available *scope* labels check in 'labeler.go'
		  #  LabelShardScopeIndex
		  #  LabelReplicaScopeIndex
		  #  LabelCHIScopeIndex
		  #  LabelCHIScopeCycleSize
		  #  LabelCHIScopeCycleIndex
		  #  LabelCHIScopeCycleOffset
		  #  LabelClusterScopeIndex
		  #  LabelClusterScopeCycleSize
		  #  LabelClusterScopeCycleIndex
		  #  LabelClusterScopeCycleOffset
		  appendScope: \"no\"

		################################################
		##
		## StatefulSet management
		##
		################################################
		statefulSet:
		  revisionHistoryLimit: 0

		################################################
		##
		## Pod management
		##
		################################################
		pod:
		  # Grace period for Pod termination.
		  # How many seconds to wait between sending
		  # SIGTERM and SIGKILL during Pod termination process.
		  # Increase this number is case of slow shutdown.
		  terminationGracePeriod: 30

		################################################
		##
		## Log parameters
		##
		################################################
		logger:
		  logtostderr: \"true\"
		  alsologtostderr: \"false\"
		  v: \"1\"
		  stderrthreshold: \"\"
		  vmodule: \"\"
		  log_backtrace_at: \"\"

		"""
}
ConfigMap: "etc-clickhouse-operator-confd-files": {
	// Template Parameters:
	//
	// NAME=etc-clickhouse-operator-confd-files
	// NAMESPACE=default
	// COMMENT=
	//
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "etc-clickhouse-operator-confd-files"
		namespace: "default"
		labels: {
			"clickhouse.altinity.com/chop": "0.20.3"
			app:                            "clickhouse-operator"
		}
	}
}
ConfigMap: "etc-clickhouse-operator-configd-files": {
	// Template Parameters:
	//
	// NAME=etc-clickhouse-operator-configd-files
	// NAMESPACE=default
	// COMMENT=
	//
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "etc-clickhouse-operator-configd-files"
		namespace: "default"
		labels: {
			"clickhouse.altinity.com/chop": "0.20.3"
			app:                            "clickhouse-operator"
		}
	}
	data: {
		"01-clickhouse-01-listen.xml": """
			<!-- IMPORTANT -->
			<!-- This file is auto-generated -->
			<!-- Do not edit this file - all changes would be lost -->
			<!-- Edit appropriate template in the following folder: -->
			<!-- deploy/builder/templates-config -->
			<!-- IMPORTANT -->
			<yandex>
			    <!-- Listen wildcard address to allow accepting connections from other containers and host network. -->
			    <listen_host>::</listen_host>
			    <listen_host>0.0.0.0</listen_host>
			    <listen_try>1</listen_try>
			</yandex>

			"""

		"01-clickhouse-02-logger.xml": """
			<!-- IMPORTANT -->
			<!-- This file is auto-generated -->
			<!-- Do not edit this file - all changes would be lost -->
			<!-- Edit appropriate template in the following folder: -->
			<!-- deploy/builder/templates-config -->
			<!-- IMPORTANT -->
			<yandex>
			    <logger>
			        <!-- Possible levels: https://github.com/pocoproject/poco/blob/develop/Foundation/include/Poco/Logger.h#L105 -->
			        <level>debug</level>
			        <log>/var/log/clickhouse-server/clickhouse-server.log</log>
			        <errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>
			        <size>1000M</size>
			        <count>10</count>
			        <!-- Default behavior is autodetection (log to console if not daemon mode and is tty) -->
			        <console>1</console>
			    </logger>
			</yandex>

			"""

		"01-clickhouse-03-query_log.xml": """
			<!-- IMPORTANT -->
			<!-- This file is auto-generated -->
			<!-- Do not edit this file - all changes would be lost -->
			<!-- Edit appropriate template in the following folder: -->
			<!-- deploy/builder/templates-config -->
			<!-- IMPORTANT -->
			<yandex>
			    <query_log replace=\"1\">
			        <database>system</database>
			        <table>query_log</table>
			        <engine>Engine = MergeTree PARTITION BY event_date ORDER BY event_time TTL event_date + interval 30 day</engine>
			        <flush_interval_milliseconds>7500</flush_interval_milliseconds>
			    </query_log>
			    <query_thread_log remove=\"1\"/>
			</yandex>

			"""

		"01-clickhouse-04-part_log.xml": """
			<!-- IMPORTANT -->
			<!-- This file is auto-generated -->
			<!-- Do not edit this file - all changes would be lost -->
			<!-- Edit appropriate template in the following folder: -->
			<!-- deploy/builder/templates-config -->
			<!-- IMPORTANT -->
			<yandex>
			    <part_log replace=\"1\">
			        <database>system</database>
			        <table>part_log</table>
			        <engine>Engine = MergeTree PARTITION BY event_date ORDER BY event_time TTL event_date + interval 30 day</engine>
			        <flush_interval_milliseconds>7500</flush_interval_milliseconds>
			    </part_log>
			</yandex>

			"""
	}
}
ConfigMap: "etc-clickhouse-operator-templatesd-files": {
	// Template Parameters:
	//
	// NAME=etc-clickhouse-operator-templatesd-files
	// NAMESPACE=default
	// COMMENT=
	//
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "etc-clickhouse-operator-templatesd-files"
		namespace: "default"
		labels: {
			"clickhouse.altinity.com/chop": "0.20.3"
			app:                            "clickhouse-operator"
		}
	}
	data: {
		"001-templates.json.example": """
			{
			  \"apiVersion\": \"clickhouse.altinity.com/v1\",
			  \"kind\": \"ClickHouseInstallationTemplate\",
			  \"metadata\": {
			    \"name\": \"01-default-volumeclaimtemplate\"
			  },
			  \"spec\": {
			    \"templates\": {
			      \"volumeClaimTemplates\": [
			        {
			          \"name\": \"chi-default-volume-claim-template\",
			          \"spec\": {
			            \"accessModes\": [
			              \"ReadWriteOnce\"
			            ],
			            \"resources\": {
			              \"requests\": {
			                \"storage\": \"2Gi\"
			              }
			            }
			          }
			        }
			      ],
			      \"podTemplates\": [
			        {
			          \"name\": \"chi-default-oneperhost-pod-template\",
			          \"distribution\": \"OnePerHost\",
			          \"spec\": {
			            \"containers\" : [
			              {
			                \"name\": \"clickhouse\",
			                \"image\": \"clickhouse/clickhouse-server:22.3\",
			                \"ports\": [
			                  {
			                    \"name\": \"http\",
			                    \"containerPort\": 8123
			                  },
			                  {
			                    \"name\": \"client\",
			                    \"containerPort\": 9000
			                  },
			                  {
			                    \"name\": \"interserver\",
			                    \"containerPort\": 9009
			                  }
			                ]
			              }
			            ]
			          }
			        }
			      ]
			    }
			  }
			}

			"""

		"default-pod-template.yaml.example": """
			apiVersion: \"clickhouse.altinity.com/v1\"
			kind: \"ClickHouseInstallationTemplate\"
			metadata:
			  name: \"default-oneperhost-pod-template\"
			spec:
			  templates:
			    podTemplates:
			      - name: default-oneperhost-pod-template
			        distribution: \"OnePerHost\"

			"""

		"default-storage-template.yaml.example": """
			apiVersion: \"clickhouse.altinity.com/v1\"
			kind: \"ClickHouseInstallationTemplate\"
			metadata:
			  name: \"default-storage-template-2Gi\"
			spec:
			  templates:
			    volumeClaimTemplates:
			      - name: default-storage-template-2Gi
			        spec:
			          accessModes:
			            - ReadWriteOnce
			          resources:
			            requests:
			              storage: 2Gi

			"""

		readme: """
			Templates in this folder are packaged with an operator and available via 'useTemplate'

			"""
	}
}
ConfigMap: "etc-clickhouse-operator-usersd-files": {
	// Template Parameters:
	//
	// NAME=etc-clickhouse-operator-usersd-files
	// NAMESPACE=default
	// COMMENT=
	//
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "etc-clickhouse-operator-usersd-files"
		namespace: "default"
		labels: {
			"clickhouse.altinity.com/chop": "0.20.3"
			app:                            "clickhouse-operator"
		}
	}
	data: {
		"01-clickhouse-user.xml": """
			<!-- IMPORTANT -->
			<!-- This file is auto-generated -->
			<!-- Do not edit this file - all changes would be lost -->
			<!-- Edit appropriate template in the following folder: -->
			<!-- deploy/builder/templates-config -->
			<!-- IMPORTANT -->
			<!--
			#
			# Template parameters available:
			#
			-->
			<yandex>
			    <users>
			        <clickhouse_operator>
			            <networks>
			                <ip>127.0.0.1</ip>
			            </networks>
			            <profile>clickhouse_operator</profile>
			            <quota>default</quota>
			        </clickhouse_operator>
			    </users>
			    <profiles>
			        <clickhouse_operator>
			            <log_queries>0</log_queries>
			            <skip_unavailable_shards>1</skip_unavailable_shards>
			            <http_connection_timeout>10</http_connection_timeout>
			            <max_concurrent_queries_for_all_users>0</max_concurrent_queries_for_all_users>
			            <os_thread_priority>0</os_thread_priority>
			        </clickhouse_operator>
			    </profiles>
			</yandex>

			"""

		"02-clickhouse-default-profile.xml": """
			<!-- IMPORTANT -->
			<!-- This file is auto-generated -->
			<!-- Do not edit this file - all changes would be lost -->
			<!-- Edit appropriate template in the following folder: -->
			<!-- deploy/builder/templates-config -->
			<!-- IMPORTANT -->
			<yandex>
			  <profiles>
			    <default>
			      <os_thread_priority>2</os_thread_priority>
			      <log_queries>1</log_queries>
			      <connect_timeout_with_failover_ms>1000</connect_timeout_with_failover_ms>
			      <distributed_aggregation_memory_efficient>1</distributed_aggregation_memory_efficient>
			      <parallel_view_processing>1</parallel_view_processing>
			      <do_not_merge_across_partitions_select_final>1</do_not_merge_across_partitions_select_final>
			      <load_balancing>nearest_hostname</load_balancing>
			    </default>
			  </profiles>
			</yandex>

			"""

		"03-database-ordinary.xml": """
			<!-- IMPORTANT -->
			<!-- This file is auto-generated -->
			<!-- Do not edit this file - all changes would be lost -->
			<!-- Edit appropriate template in the following folder: -->
			<!-- deploy/builder/templates-config -->
			<!-- IMPORTANT -->
			<!--  Remove it for ClickHouse versions before 20.4 -->
			<yandex>
			    <profiles>
			        <default>
			            <default_database_engine>Ordinary</default_database_engine>
			        </default>
			    </profiles>
			</yandex>

			"""
	}
}
Secret: "clickhouse-operator": {
	//
	// Template parameters available:
	//   NAMESPACE=default
	//   COMMENT=
	//   OPERATOR_VERSION=0.20.3
	//   CH_USERNAME_SECRET_PLAIN=clickhouse_operator
	//   CH_PASSWORD_SECRET_PLAIN=clickhouse_operator_password
	//
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:      "clickhouse-operator"
		namespace: "default"
		labels: {
			"clickhouse.altinity.com/chop": "0.20.3"
			app:                            "clickhouse-operator"
		}
	}
	type: "Opaque"
	stringData: {
		username: "clickhouse_operator"
		password: "clickhouse_operator_password"
	}
}
Deployment: "clickhouse-operator": {
	// Template Parameters:
	//
	// NAMESPACE=default
	// COMMENT=
	// OPERATOR_IMAGE=altinity/clickhouse-operator:0.21.0@sha256:8f481827d60398d0c553ea7c1726c0acec4ca893af710333ea5aa795ca96c0b9
	// OPERATOR_IMAGE_PULL_POLICY=IfNotPresent
	// METRICS_EXPORTER_IMAGE=altinity/metrics-exporter:0.21.0@sha256:a9743f3c012400e122abc470a3e4c95a7ab25ab3025df1e6d7f98af75f627215
	// METRICS_EXPORTER_IMAGE_PULL_POLICY=IfNotPresent
	//
	// Setup Deployment for clickhouse-operator
	// Deployment would be created in kubectl-specified namespace
	kind:       "Deployment"
	apiVersion: "apps/v1"
	metadata: {
		name:      "clickhouse-operator"
		namespace: "default"
		labels: {
			"clickhouse.altinity.com/chop": "0.20.3"
			app:                            "clickhouse-operator"
		}
	}
	spec: {
		replicas: 1
		selector: matchLabels: app: "clickhouse-operator"
		template: {
			metadata: {
				labels: app: "clickhouse-operator"
				annotations: {
					"prometheus.io/port":   "8888"
					"prometheus.io/scrape": "true"
				}
			}
			spec: {
				serviceAccountName: "clickhouse-operator"
				volumes: [{
					name: "etc-clickhouse-operator-folder"
					configMap: name: "etc-clickhouse-operator-files"
				}, {
					name: "etc-clickhouse-operator-confd-folder"
					configMap: name: "etc-clickhouse-operator-confd-files"
				}, {
					name: "etc-clickhouse-operator-configd-folder"
					configMap: name: "etc-clickhouse-operator-configd-files"
				}, {
					name: "etc-clickhouse-operator-templatesd-folder"
					configMap: name: "etc-clickhouse-operator-templatesd-files"
				}, {
					name: "etc-clickhouse-operator-usersd-folder"
					configMap: name: "etc-clickhouse-operator-usersd-files"
				}]
				containers: [{
					name:            "clickhouse-operator"
					image:           "altinity/clickhouse-operator:0.21.0@sha256:8f481827d60398d0c553ea7c1726c0acec4ca893af710333ea5aa795ca96c0b9"
					imagePullPolicy: "IfNotPresent"
					volumeMounts: [{
						name:      "etc-clickhouse-operator-folder"
						mountPath: "/etc/clickhouse-operator"
					}, {
						name:      "etc-clickhouse-operator-confd-folder"
						mountPath: "/etc/clickhouse-operator/conf.d"
					}, {
						name:      "etc-clickhouse-operator-configd-folder"
						mountPath: "/etc/clickhouse-operator/config.d"
					}, {
						name:      "etc-clickhouse-operator-templatesd-folder"
						mountPath: "/etc/clickhouse-operator/templates.d"
					}, {
						name:      "etc-clickhouse-operator-usersd-folder"
						mountPath: "/etc/clickhouse-operator/users.d"
					}]
					env: [{
						// Pod-specific
						// spec.nodeName: ip-172-20-52-62.ec2.internal
						name: "OPERATOR_POD_NODE_NAME"
						valueFrom: fieldRef: fieldPath: "spec.nodeName"
					}, {
						// metadata.name: clickhouse-operator-6f87589dbb-ftcsf
						name: "OPERATOR_POD_NAME"
						valueFrom: fieldRef: fieldPath: "metadata.name"
					}, {
						// metadata.namespace: kube-system
						name: "OPERATOR_POD_NAMESPACE"
						valueFrom: fieldRef: fieldPath: "metadata.namespace"
					}, {
						// status.podIP: 100.96.3.2
						name: "OPERATOR_POD_IP"
						valueFrom: fieldRef: fieldPath: "status.podIP"
					}, {
						// spec.serviceAccount: clickhouse-operator
						// spec.serviceAccountName: clickhouse-operator
						name: "OPERATOR_POD_SERVICE_ACCOUNT"
						valueFrom: fieldRef: fieldPath: "spec.serviceAccountName"
					}, {
						// Container-specific
						name: "OPERATOR_CONTAINER_CPU_REQUEST"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "requests.cpu"
						}
					}, {
						name: "OPERATOR_CONTAINER_CPU_LIMIT"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "limits.cpu"
						}
					}, {
						name: "OPERATOR_CONTAINER_MEM_REQUEST"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "requests.memory"
						}
					}, {
						name: "OPERATOR_CONTAINER_MEM_LIMIT"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "limits.memory"
						}
					}]
				}, {
					name:            "metrics-exporter"
					image:           "altinity/metrics-exporter:0.21.0@sha256:a9743f3c012400e122abc470a3e4c95a7ab25ab3025df1e6d7f98af75f627215"
					imagePullPolicy: "IfNotPresent"
					volumeMounts: [{
						name:      "etc-clickhouse-operator-folder"
						mountPath: "/etc/clickhouse-operator"
					}, {
						name:      "etc-clickhouse-operator-confd-folder"
						mountPath: "/etc/clickhouse-operator/conf.d"
					}, {
						name:      "etc-clickhouse-operator-configd-folder"
						mountPath: "/etc/clickhouse-operator/config.d"
					}, {
						name:      "etc-clickhouse-operator-templatesd-folder"
						mountPath: "/etc/clickhouse-operator/templates.d"
					}, {
						name:      "etc-clickhouse-operator-usersd-folder"
						mountPath: "/etc/clickhouse-operator/users.d"
					}]
					env: [{
						// Pod-specific
						// spec.nodeName: ip-172-20-52-62.ec2.internal
						name: "OPERATOR_POD_NODE_NAME"
						valueFrom: fieldRef: fieldPath: "spec.nodeName"
					}, {
						// metadata.name: clickhouse-operator-6f87589dbb-ftcsf
						name: "OPERATOR_POD_NAME"
						valueFrom: fieldRef: fieldPath: "metadata.name"
					}, {
						// metadata.namespace: kube-system
						name: "OPERATOR_POD_NAMESPACE"
						valueFrom: fieldRef: fieldPath: "metadata.namespace"
					}, {
						// status.podIP: 100.96.3.2
						name: "OPERATOR_POD_IP"
						valueFrom: fieldRef: fieldPath: "status.podIP"
					}, {
						// spec.serviceAccount: clickhouse-operator
						// spec.serviceAccountName: clickhouse-operator
						name: "OPERATOR_POD_SERVICE_ACCOUNT"
						valueFrom: fieldRef: fieldPath: "spec.serviceAccountName"
					}, {
						// Container-specific
						name: "OPERATOR_CONTAINER_CPU_REQUEST"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "requests.cpu"
						}
					}, {
						name: "OPERATOR_CONTAINER_CPU_LIMIT"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "limits.cpu"
						}
					}, {
						name: "OPERATOR_CONTAINER_MEM_REQUEST"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "requests.memory"
						}
					}, {
						name: "OPERATOR_CONTAINER_MEM_LIMIT"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "limits.memory"
						}
					}]
					ports: [{
						containerPort: 8888
						name:          "metrics"
					}]
				}]
			}
		}
	}
}
Service: "clickhouse-operator-metrics": {
	// Template Parameters:
	//
	// NAMESPACE=default
	// COMMENT=
	//
	// Setup ClusterIP Service to provide monitoring metrics for Prometheus
	// Service would be created in kubectl-specified namespace
	// In order to get access outside of k8s it should be exposed as:
	// kubectl --namespace prometheus port-forward service/prometheus 9090
	// and point browser to localhost:9090
	kind:       "Service"
	apiVersion: "v1"
	metadata: {
		name:      "clickhouse-operator-metrics"
		namespace: "default"
		labels: {
			"clickhouse.altinity.com/chop": "0.20.3"
			app:                            "clickhouse-operator"
		}
	}
	spec: {
		ports: [{
			port: 8888
			name: "clickhouse-operator-metrics"
		}]
		selector: app: "clickhouse-operator"
	}
}
