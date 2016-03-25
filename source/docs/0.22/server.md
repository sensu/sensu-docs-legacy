---
version: 0.22
category: "Reference Docs"
title: "Sensu Server"
next:
  url: "rabbitmq"
  text: "RabbitMQ Configuration"
---

# The Sensu Server

## Reference Documentation

- [What is the Sensu server?](#what-is-the-sensu-server)
- [Sensu Core vs Sensu Enterprise](#sensu-core-vs-sensu-enterprise)
- [Check execution scheduling](#check-execution-scheduling)
  - [Check scheduling algorithm & synchronization](#check-scheduling-algorithm--synchronization)
- [Event processing](#event-processing)
- [Automated leader election](#automated-leader-election)
  - [Leadership duties](#leadership-duties)
- [Scaling Sensu](#scaling-sensu)

## What is the Sensu server?

The Sensu server schedules and publishes [check execution requests][requests] to
[client subscriptions][subscriptions] (via a [Publish/Subscribe model][pubsub]),
and provides a scalable [event processing platform][event-processor] for
processing check results and monitoring events.

## Sensu Core vs Sensu Enterprise

The Sensu server comes in two flavors: the open-source [Sensu Core][sensu-core]
(via the `sensu-server` process), and [Sensu Enterprise][enterprise] (via the
`sensu-enterprise` process). To learn more about the differences between
Sensu Core and Sensu Enterprise, [please visit the Sensu website][compare].

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
server leader](#leadership-duties)). Checks are scheduled by querying Sensu's
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
checks](checks#standalone-checks) &ndash; a check defined on the Sensu server
and a matching standalone check defined on a Sensu client should also stay in
sync with each other (again assuming that system clocks are in sync, and the
check names and `interval`s are consistent).

## Event processing

The Sensu server provides a scalable event processor. Event processing involves
conversion of [check results](checks#check-results) into Sensu events, and then
applying any defined [event filters](filters), [event data mutators](mutators),
and [event handlers](handlers). All event processing happens on a Sensu server
system.

The event processing workflow happens in the following order:

> **Event** -> **Filter** -> **Mutator** -> **Handler**

_NOTE: events that are filtered out (i.e. removed) by Sensu [event
filters](filters) will not continue to be mutated by [event data
mutators](mutators) or [event handlers](handlers)._

Sensu's event processing capabilities can be distributed among multiple Sensu
servers in a Sensu cluster. For more information on configuring a Sensu cluster,
please see [Scaling Sensu](#scaling-sensu) (below).

## Automated leader election

The Sensu server processes (i.e. `sensu-server` and `sensu-enterprise`) are
designed to [scale horizontally][wiki-scalability] (i.e. by adding systems).
No additional configuration is required to run a cluster of Sensu servers, other
than the location of the [transport](transport) and [data store](data-store).
When Sensu servers start, they will automatically identify or elect a "leader",
which leader will fulfill certain [leadership duties](#leadership-duties).

All Sensu servers in a Sensu cluster monitor the state of cluster leadership on
a 10-second interval, automatically electing a new leader if the current leader
hasn't confirmed leadership in more than 30 seconds.

### Leadership duties

In a Sensu server cluster, there are a few duties which are not distributed to
all of the Sensu servers in the cluster. The following duties are only provided
by the Sensu server leader:

- **Check request publisher**. The Sensu server leader is responsible for
  publishing check requests to the transport for all configured checks. See
  [check execution scheduling](#check-execution-scheduling) for more
  information.
- **Client monitor**. The Sensu server leader is responsible for monitoring the
  [client registry][client-registry] and creating [client keepalive
  events][keepalive-events] for stale clients.
- **Check result monitor**. The Sensu server leader is responsible for
  monitoring check results and creating TTL events for check results with
  expired [check TTLs][check-ttls]
- **Check result aggregation pruning**. The Sensu server leader is responsible
  for monitoring check aggregates and pruning stale aggregate results.

## Scaling Sensu

Coming soon...


[requests]:           checks#check-requests
[subscriptions]:      clients#client-subscriptions
[pubsub]:             checks#pubsub-checks
[event-processor]:    architecture#event-processor
[wiki-scalability]:   https://en.wikipedia.org/wiki/Scalability#Horizontal_and_vertical_scaling
[client-registry]:    clients#registration-and-registry
[check-ttls]:         checks#check-ttls
[keepalive-events]:   clients#keepalive-events
[sensu-core]:         https://sensuapp.org/
[enterprise]:         https://sensuapp.org/sensu-enterprise
[compare]:            https://sensuapp.org/#compare
