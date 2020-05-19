# NetMeta

⚠️ **PRE-RELEASE**: This is a work in progress - please watch this repo for news.

NetMeta is a scalable network observability toolkit optimized for performance.

It captures, aggregates and analyzes events from a variety of data sources:

* sFlow
* NetFlow/IPFIX
* Linux NFLOG (soon)
* Linux conntrack (soon)
* Web server logs (soon)
* Scamper traces (soon)

<img src="https://i.imgur.com/gboWSxV.png" width="550px" alt="Graph showing top destination IPs" />

<img src="https://i.imgur.com/W5HnvR6.png" width="550px" alt="Graph showing source code histogram" />

NetMeta is powered by a number of great open source projects like ClickHouse, 
Kafka, goflow, Strimzi, clickhouse-operator, Kubernetes, and k3s.

NetMeta is **alpha software** and subject to change.

### sFlow vs Netflow/IPFIX

**sFlow** is a very simple protocol. In its simplest form, every n-th packet is sampled and the packet header is sent
to the collector. That's it. The rate of samples sent to the collector and the bandwidth required is very predictable
and proportional to observed pps.

**Netflow/IPFIX** also samples every n-th packet, but pre-aggregates data on the network device, typically identified by
its 5-tuple, and exports metadata for all active flows at regular intervals. Netflow aggregation is stateful and the 
device needs to maintain a flow table. This is particularly useful for use cases that care about individual flows 
(connections), like network security monitoring. As long as most packets belong to a small number of flows, much fewer
samples are sent to the collector at the same sampling rate.

Of course, pre-aggregation means that we lose data about the individual packets. This is fine for use cases like traffic
 accounting, but has disadvantages for observability:


* Resolution is inherently limited by the aggregation interval (flow timeout). The lower end for this is typically 10s
  or more - you couldn't distinguish a 1s burst at 100 Gbps from a 10s burst at 10 Gbps.
 
* Does this flow consist of only SYN packets? SYN-ACKs? A mixture of both? We can't tell, because the TCP flags in the 
  flow metadata are a union of all individual packet's TCP flags.

* In adverserial network conditions, like DDoS attacks using random source IP and ports, each packet can represent a new
  flow. This can quickly fill up the flow table, resulting in dropped flows, losing visibility in a situation where it
  would be particularly useful. The rate of samples sent to the collector is hard to reason about, since it is
  implementation-specific and depends on flow cardinality, table size and timeouts.
  
* Maintaining the stateful flow table in the router is very expensive, especially at high rates. Modern column stores 
  like ClickHouse are extremely efficient at aggregating data in arbitrary dimensions - there's no need to do it on the router.

If possible, we recommend using sFlow. For a 10 Gbps link, a typical sampling rate is 1:2000.
A worst-case flood at line rate would generate 7kpps of sFlow samples.

If Netflow/IPFIX is used, make sure to pick an appropriate sampling rate and flow table size for worst-case workloads. There are many different implementations that perform very differently - refer to vendor documentation for specifics.

### API Stability

NetMeta is alpha software and subject to change. It exposes the following APIs:

* The cluster configuration file for single-node deployments.
* ClickHouse SQL schema for raw database access.
* Protobuf schemas for ingestion for writing custom processors.

One NetMeta has stabilized, these APIs will be stable and backwards compatible.

## Deployment

NetMeta includes a production-ready single node deployment that scales to up to ~100k events/s and billions of database rows.

Ingestion performance is limited by CPU performance and disk bandwidth. 
Query performance is limited by disk and memory bandwidth, as well as total amount of available memory for larger in-memory aggregations.

Most reads/writes are sequential due to heavy use of batching in all parts of the stack, 
and it works fine even on network storage or spinning disks. We recommend local NVMe drives for best performance.

NetMeta can scale to millions of events per seconds in multi-node deployments.

### Single-node deployment

Single-node deployment is tested on CentOS/RHEL 8, Debian 10 and Ubuntu 18.04 LTS. 

We strongly recommend deploying NetMeta on a dedicated VM or physical server.

Deployment is designed to be compatible with hosts that are managed by an organization's configuration management baseline.
The NetMeta single-node deployment is self-contained and does not touch any of the system's global configuration.
Make sure to read and understand install.sh before you run it! It can co-exist with other services on the same machine,
but we do not recommend that.

It brings its own minimal Kubernetes cluster and container runtime and has no dependencies beyond that.

Build dependencies:

- Python >=3.6 (rules_docker)
- C compiler toolchain (protoc)

Install build dependencies on RHEL/CentOS 8 and Fedora:

    dnf install -y python3 jq "@Development Tools"
    
    # TODO(leo): ugh - figure out how to convince Bazel to use the python3 binary
    ln -s /usr/bin/python3 /usr/local/bin/python

Install build dependencies on Debian Buster:
    
    apt install -y protobuf-compiler jq gcc

We will eventually provide pre-built images, for now, the build dependencies are always required.

Quick start:

    git clone https://github.com/leoluk/NetMeta && cd NetMeta
    
    # Install dependencies
    ./install.sh
    
    # Build containers
    scripts/build_containers.sh
    
    # Deploy single node
    cd deploy/single-node
    cue apply ./...

### nxtOS

Stay tuned - NetMeta will be a first-class citizen on our nxtOS Kubernetes cluster operating system. 

### Kubernetes

NetMeta works on any Kubernetes cluster that supports LoadBalancer and Ingress objects and can provision storage. It's up to you to carefully read the deployment code and cluster role assigments to make sure it works with your cluster. Note that we use two operators, which require cluster-admin permissions since CRDs are global ([Strimzi](https://strimzi.io/docs/master) for Kafka and [clickhouse-operator](https://github.com/Altinity/clickhouse-operator)).

All pieces of NetMeta are installed into a single namespace. By default, this is ``default``, which is probably not what you want. You can change the target namespace in the deployment config.

Please contact us if you need help porting NetMeta to an existing k8s cluster.

### Multi-node deployment

Work In Progress. Please contact us if you're interested in large-scale deployments.

### Architecture

<img src="https://i.imgur.com/j8lBemH.png" alt="Single Node Dataflow" width="350px" />

---

(C) 2020 Nexantic GmbH. This is not (yet?) an official Nexantic product. 

This software is provided "as-is" and
without any express or implied warranties, including, without limitation, the implied warranties of
merchantability and fitness for a particular purpose. 
