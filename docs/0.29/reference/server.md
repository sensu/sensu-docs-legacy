---
title: "Server"
description: "Reference documentation for the Sensu Server."
version: 0.28
weight: 1
---

# The Sensu Server

## Reference documentation

- [What is the Sensu server?](#what-is-the-sensu-server)
- [Sensu Core vs Sensu Enterprise](#sensu-core-vs-sensu-enterprise)
- [Check execution scheduling](#check-execution-scheduling)
  - [Check scheduling algorithm & synchronization](#check-scheduling-algorithm--synchronization)
- [Event processing](#event-processing)
- [Automated leader election](#automated-leader-election)
  - [Leadership duties](#leadership-duties)
- [Scaling Sensu](#scaling-sensu)

## What is the Sensu server?

The Sensu server schedules and publishes [check execution requests][1] to
[client subscriptions][2] (via a [Publish/Subscribe model][3]), and provides a
scalable [event processing platform][4] for processing check results and
monitoring events.

## Sensu Core vs Sensu Enterprise

The Sensu server comes in two flavors: the open-source [Sensu Core][5] (via the
`sensu-server` process), and [Sensu Enterprise][6] (via the `sensu-enterprise`
process). To learn more about the differences between Sensu Core and Sensu
Enterprise, [please visit the Sensu website][7].

_NOTE: Sensu Enterprise (i.e. the `sensu-enterprise` process) was designed to be
a drop-in replacement for the Sensu Core server and API (i.e. the `sensu-server`
and `sensu-api`). As such, any mention of "the Sensu server" in the Sensu
documentation also applies to the `sensu-enterprise` process, for Sensu
Enterprise users._

_WARNING: as noted above, the `sensu-enterprise` process is designed to replace
both of the Sensu Core `sensu-server` and `sensu-api` processes. Because Sensu
Enterprise will load the same configuration as Sensu Core, it is important that
the Sensu Core processes are stopped before starting Sensu Enterprise to avoid
known conflicts and processing errors such as attempting to bind on the same
ports, etc._

## Check execution scheduling

Check execution scheduling is performed by the Sensu server (or the [Sensu
server leader][8]). Checks are scheduled by querying Sensu's
configuration for defined checks &ndash; excluding check with the attributes
`"standalone": true` or `"publish": false` &ndash; and calculating when
executions should occur based on their defined `interval`s.

### Check scheduling algorithm & synchronization

Sensu uses an internal algorithm for determining a unique "cadence" for Sensu
checks, which uniqueness is based on the check name and `interval`. This
algorithm outputs a value in milliseconds which the Sensu server will use as an
offset before the next check request should be published. In practice, this
means that &ndash; assuming system clocks are in sync between disparate Sensu
servers &ndash; check requests for a given check (based on the check name) will
be published at the <abbr title="typically accurate within 500ms">exact same
time</abbr>. The also means that in the event of a Sensu server restart and/or
Sensu leader re-election (i.e. if a new Sensu server leader is elected to
replace an unresponsive leader), check execution scheduling intervals should
remain consistent.

In fact, because this algorithm is also shared by the Sensu client &ndash; which
provides decentralized check execution scheduling in the form of [standalone
checks][22] &ndash; a check defined on the Sensu server and a matching
standalone check defined on a Sensu client should also stay in sync with each
other (again assuming that system clocks are in sync, and the check names and
`interval`s are consistent).

## Event processing

The Sensu server provides a scalable event processor. Event processing involves
conversion of [check results][9] into Sensu events, and then
applying any defined [event filters][10], [event data mutators][11],
and [event handlers][12]. All event processing happens on a Sensu server
system.

The event processing workflow happens in the following order:

> **Event** -> **Filter** -> **Mutator** -> **Handler**

_NOTE: events that are filtered out (i.e. removed) by Sensu [event
filters](filters) will not continue to be mutated by [event data
mutators](mutators) or [event handlers](handlers)._

Sensu's event processing capabilities can be distributed among multiple Sensu
servers in a Sensu cluster. For more information on configuring a Sensu cluster,
please see [Scaling Sensu][13] (below).

## Automated leader election

The Sensu server processes (i.e. `sensu-server` and `sensu-enterprise`) are
designed to [scale horizontally][14] (i.e. by adding systems). No additional
configuration is required to run a cluster of Sensu servers, other than the
location of the [transport][15] and [data store][16]. When Sensu
servers start, they will automatically identify or elect a "leader", which
leader will fulfill certain [leadership duties][17].

All Sensu servers in a Sensu cluster monitor the state of cluster leadership on
a 10-second interval, automatically electing a new leader if the current leader
hasn't confirmed leadership in more than 30 seconds.

### Leadership duties

In a Sensu server cluster, there are a few duties which are not distributed to
all of the Sensu servers in the cluster. The following duties are only provided
by the Sensu server leader:

- **Check request publisher**. The Sensu server leader is responsible for
  publishing check requests to the transport for all configured checks. See
  [check execution scheduling][18] for more information.
- **Client monitor**. The Sensu server leader is responsible for monitoring the
  [client registry][19] and creating [client keepalive events][20] for stale clients.
- **Check result monitor**. The Sensu server leader is responsible for
  monitoring check results and creating TTL events for check results with
  expired [check TTLs][21]
- **Check result aggregation pruning**. The Sensu server leader is responsible
  for monitoring check aggregates and pruning stale aggregate results.

## Scaling Sensu

Coming soon...


[1]:  checks.html#check-requests
[2]:  clients.html#client-subscriptions
[3]:  checks.html#pubsub-checks
[4]:  ../overview/architecture.html#event-processor
[5]:  https://sensuapp.org/
[6]:  https://sensuapp.org/enterprise
[7]:  https://sensuapp.org/#compare
[8]:  #leadership-duties
[9]:  checks.html#check-results
[10]: filters.html
[11]: mutators.html
[12]: handlers.html
[13]: #scaling-sensu
[14]: https://en.wikipedia.org/wiki/Scalability#Horizontal_and_vertical_scaling
[15]: transport.html
[16]: data-store.html
[17]: #leadership-duties
[18]: #check-execution-scheduling
[19]: clients.html#registration-and-registry
[20]: clients.html#keepalive-events
[21]: checks.html#check-ttls
[22]: checks.html#standalone-checks
