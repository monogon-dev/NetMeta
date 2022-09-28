# Ingest

## sFlow vs Netflow/IPFIX

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

* In adversarial network conditions, like DDoS attacks using random source IP and ports, each packet can represent a new
  flow. This can quickly fill up the flow table, resulting in dropped flows, losing visibility in a situation where it
  would be particularly useful. The rate of samples sent to the collector is hard to reason about, since it is
  implementation-specific and depends on flow cardinality, table size and timeouts.

* Maintaining the stateful flow table in the router is very expensive, especially at high rates. Modern column stores
  like ClickHouse are extremely efficient at aggregating data in arbitrary dimensions - there's no need to do it on the router.

If possible, we recommend using sFlow. For a 10 Gbps link, a typical sampling rate is 1:2000.
A worst-case flood at line rate would generate 7kpps of sFlow samples.

If Netflow/IPFIX is used, make sure to pick an appropriate sampling rate and flow table size for worst-case workloads.
There are many different implementations that perform very differently - refer to vendor documentation for specifics.

Depending on your aggregation interval, you may want to set a minimum display interval in the NetMeta config:

    dashboardDisplay: minInterval: "15s"

## Host sFlow collector

We recommend [hsflowd](https://github.com/sflow/host-sflow) for host-based flow collection.

Example /etc/hsflowd.conf config:

    sflow {
      collector { ip=flowmon.example.com udpport=6343 }
      nflog { group = 5  probability = 0.0025 }
    }

You need to create iptables (or nftables) rules that send samples to hsflowd's nflog group.
An example config for plain iptables looks like this:

```bash
# hsflowd sampling. Probability needs to match /etc/hsflowd.conf (it will be used to calculate sampling rate).

MOD_STATISTIC="-m statistic --mode random --probability 0.0025"
NFLOG_CONFIG="--nflog-group 5 --nflog-prefix SFLOW"
INTERFACE=eno1

iptables -t raw -I PREROUTING -i $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
iptables -t nat -I POSTROUTING -o $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
iptables -t nat -I OUTPUT -o $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
ip6tables -t raw -I PREROUTING  -i $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
ip6tables -t nat -I POSTROUTING -o $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
ip6tables -t nat -I OUTPUT -o $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
```

For Linux hosts, there's a custom agent on the roadmap that directly pushes to Kafka to avoid the sFlow detour
and get better data that includes the flow direction.
In the meantime, hsflowd is your best bet for collecting samples from a host.

## Port Mirror collector

If you have an interface pair that receives a copy of your traffic like a port mirror or fibre tap, you can use
NetMeta's integrated collector to directly sample traffic without requiring an sFlow collector.

You can either deploy the collector to a remote host, or have it deployed automatically on your monitoring host:

```cue
netmeta: config: {
    [...]
    portMirror: {
      interfaces: "tap_rx:tap_tx,tap2_rx:tap2_tx"
      sampleRate: 100
    }
}
```

You have to configure which interfaces the collector should listen on. You can have multiple pairs by
separating them with a comma. You can also configure the sample rate.
