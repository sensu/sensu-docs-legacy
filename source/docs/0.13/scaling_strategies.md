---
version: "0.13"
category: "Advanced Topics"
title: "Scaling Strategies"
---

# Scaling Sensu at a Single Site {#scaling-sensu-at-a-single-site}

Sensu made of multiple components, each has its own scaling considerations.
For a real-life example of how to scale a Sensu Cluster, see
[Failshell.io's excellent writeup](http://failshell.io/sensu/high-availability-sensu/)

## Sensu Server

The Sensu server component scales easily. Simply run multiple instances
of the sensu-server process pointing to the same Rabbitmq and Redis instances.

The sensu-server component does its own internal master election.

## Sensu API

The Sensu API component is a stateless http frontend. It can be scaled with 
traditional http load-balancing strategies. (HAproxy, Nginx, etc)

## RabbitMQ

Please see the RabbitMQ [documentation](https://www.rabbitmq.com/clustering.html)
on clustering for building a RabbitMQ cluster.

## Redis

For the most part, Redis can only have a single master at one time. However, building
multiple Redis instances can provide fault tolerance. See the 
[Redis Sentinel](http://redis.io/topics/sentinel) documentation on how to build
a Redis with automatic promotion of slaves.

# Scaling Sensu Across Multiple Sites {#scaling-sensu-across-multiple-sites}

Every distributed system, Sensu included, but take into account special
considerations when scaling across multiple sites (datacenters) where
the networking (WAN) will be unreliable.

For the purpose of this documentation each site will be referred to as a 
"Datacenter".

## Strategy 1: Isolated Clusters Aggregated by Uchwa

This strategy involves building isolated, independent Sensu server/clusters
at each datacenter, and then using Uchiwa\'s multi-datacenter configuration
option to get an aggregate view of the events and clients.

### Pros

* WAN instability does *not* lead to flapping sensu checks
* Sensu operation continues un-interrupted during a WAN outage
* The overall architecture is easier to understand and troubleshoot

### Cons

* WAN outages mean a whole Datacenter can go dark and not set off alerts 
(cross-datacenter checks are therefor essential)
* WAN instability can lead to a lack of visibility as Uchiwa may
not be able to connect to the remote Sensu APIs
* Requires all the Sensu infrastructure in every datacenter

## Strategy 2: Centralized Sensu and Distributed  RabbitMQ

Sensu clients only need to connect to a RabbitMQ server to submit events.
One scaling strategy is to centralize the Sensu infrastructure in one location,
and have remote sites only have a remote RabbitMQ broker, which in turn forwards
events to the central cluster.

This is done either by the RabbitMQ [Federation plugin](https://www.rabbitmq.com/federation.html)
or via the [Shovel](https://www.rabbitmq.com/shovel.html) plugin. (See a comparison 
[here](https://www.rabbitmq.com/distributed.html))

Note: This is picking Availability and Partition Tolerance over Consistency 
with RabbitMQ. 

### Pros

* Decreased infrastructure necessary at remote Datacenters
* All Senus server alerts originate from a single source

### Cons

* WAN instability can result in floods of client keepalive alerts. 
([Check Dependencies](http://sensuapp.org/docs/0.13/checks#check-dependencies) 
can help with this)
* Increased RabbitMQ configuration complexity.
* All clients "appear" to be in the same datacenter in Uchiwa

## Strategy 3: Centralized Sensu and Directly Connected Clients

All Sensu clients execute checks locally. Their only interaction with
Sensu servers is to push events onto RabbitMQ. Therefore, remote clients
can connect directly to a remote RabbitMQ broker over the WAN.

### Pros

* Very simple architecture, no additional infrastructure needed at remote sites
* Centralized alert handling

### Cons

* Keepalive failures are now indistinguishable from WAN instability
* Lots of remote clients means lots of TCP connections over the WAN
* All clients "appear" to be in the same datacenter in Uchiwa
