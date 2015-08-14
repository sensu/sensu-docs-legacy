---
version: 0.20
category: "Reference Docs"
title: "RabbitMQ Configuration"
next:
  url: "redis"
  text: "Redis Configuration"
---

# Overview

This reference document provides information to help you:

- Understand what RabbitMQ is
- Understand how Sensu uses RabbitMQ
- How to configure the Sensu RabbitMQ connection
- How to configure RabbitMQ
- How to secure RabbitMQ in production
- How to configure RabbitMQ for High Availability (HA)

# What is RabbitMQ?

RabbitMQ is a message bus, which [describes itself](http://www.rabbitmq.com/features.html) as _"a messaging broker - an intermediary for messaging. It gives your applications a common platform to send and receive messages, and your messages a safe place to live until received"_.

You can visit the official RabbitMQ website to learn more: [rabbitmq.com](http://www.rabbitmq.com/)

# How Sensu uses RabbitMQ

Sensu services use RabbitMQ (the default Sensu transport) to communicate with one another. Every Sensu service requires access to the same instance of RabbitMQ or a RabbitMQ cluster to function. Sensu check requests and check results are sent over RabbitMQ to the approprate Sensu services.

# Anatomy of a RabbitMQ definition

The RabbitMQ definition uses the `"rabbitmq": {}` definition scope.

### Definition attributes

host
: description
  : The RabbitMQ hostname or IP address (recommended).
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

port
: description
  : The RabbitMQ TCP port.
: required
  : false
: type
  : Integer
: default
  : `5672`
: example
  : ~~~ shell
    "port": 5671
    ~~~

vhost
: description
  : The RabbitMQ vhost to use.
: required
  : false
: type
  : String
: default
  : `/`
: example
  : ~~~ shell
    "vhost": "/sensu"
    ~~~

user
: description
  : The RabbitMQ user name.
: required
  : false
: type
  : String
: default
  : `guest`
: example
  : ~~~ shell
    "user": "sensu"
    ~~~

password
: description
  : The RabbitMQ user password.
: required
  : false
: type
  : String
: default
  : `guest`
: example
  : ~~~ shell
    "password": "secret"
    ~~~

prefetch
: description
  : The RabbitMQ AMQP consumer prefetch value, setting the number of unacknowledged messages allowed for the channel. This option can be used as a flow control mechanism, to tune message throughput performance. _NOTE: an increased prefetch value should be used if you are experiencing a backlog of messages in RabbitMQ while the Sensu server(s) load remains low. Increasing the prefetch value will effect the distribution of messages in Sensu configurations with more than one Sensu server._
: required
  : false
: type
  : Integer
: default
  : `1`
: example
  : ~~~ shell
    "prefetch": 100
    ~~~

ssl
: description
  : A set of attributes that configure SSL encryption for the connection. SSL encryption will be enabled if this option is configured.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "ssl": {}
    ~~~

#### SSL attributes

The following attributes are configured within the `"ssl": {}` RabbitMQ definition attribute scope.

cert_chain_file
: description
  : The file path for the chain of X509 SSL certificates in the PEM format for the SSL connection.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "cert_chain_file": "/etc/sensu/ssl/cert.pem"
    ~~~

private_key_file
: description
  : The file path for the SSL private key in the PEM format.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "private_key_file": "/etc/sensu/ssl/key.pem"
    ~~~

# Configuring RabbitMQ

To configure RabbitMQ, please refer to the [official RabbitMQ configuration documentation](https://www.rabbitmq.com/configure.html).

# Security

Sensu leverages RabbitMQ access control and SSL for secure communication. Sensu was created to deal with dynamic infrastructure, where it is not feasible to maintain strict firewall rules. It is common to expose RabbitMQ’s SSL port (`5671`) without any restrictions, if certain conditions are met. Removing the default RabbitMQ user `guest` is mandatory and using a generated user name, password, and vhost is highly recommended. Enabling SSL peer certificate verification will ensure only trusted RabbitMQ clients with the correct private key are able to connect.

# Configuring RabbitMQ for High Availability (HA)

For the best results when configuring HA RabbitMQ, we recommend the following:

## Use a three node (RAM nodes) RabbitMQ cluster

### Hardware requirements

The Sensu transport does not require message persistence, making throughput the primary concern for RabbitMQ (i.e. memory is more important than disk performance). When starting with a RabbitMQ cluster it is important to use systems (e.g. virtual machines) with sufficient compute, memory, and network resources. Although it's challenging to provide "recommended hardware requirements" for the broad variety of Sensu deployments, we have found that starting with three nodes equivalent to [AWS EC2 m3.medium instances](http://aws.amazon.com/ec2/instance-types/#M3) generally provides a solid baseline for monitoring upwards of 1000+ servers, each reporting 10-20 checks & metrics at 10-second resolution.

### RabbitMQ cluster configuration

When configuring a RabbitMQ cluster, the recommended method is via the RabbitMQ configuration file `/etc/rabbitmq/rabbitmq.conf`. For more on using the RabbitMQ configuration file for auto-configuration of a cluster, please refer to the [official RabbitMQ clustering documentation](https://www.rabbitmq.com/clustering.html), under the heading "Auto-configuration of a cluster".

A RabbitMQ cluster offers several methods of handling network partitions. A RabbitMQ cluster should not span regions (e.g. WAN links), as doing so would increase latency and the probability of network partitions. The recommended network partition handling mode for a three node RabbitMQ cluster is [pause_minority](https://www.rabbitmq.com/partitions.html#pause-minority). The [pause_minority](https://www.rabbitmq.com/partitions.html#pause-minority) mode will cause the RabbitMQ node(s) in the partition minority to pause, triggering connected clients to reconnect to a "healthy" node in the partition majority.

The following is a portion of a `/etc/rabbitmq/rabbitmq.conf` configuration file, which configures the auto-configuration of a three node RabbitMQ cluster that uses the `pause_minority` network partition handling mode.

~~~ erlang
[
  {rabbit, [
    {cluster_nodes, {['rabbit@host-1', 'rabbit@host-2', 'rabbit@host-3'], ram}},
    {cluster_partition_handling, pause_minority},
    ...
  ]}
].
~~~

### Mirroring the Sensu queues

WIP

~~~
rabbitmqctl set_policy ha-sensu "^(results$|keepalives$)" '{"ha-mode":"all", "ha-sync-mode":"automatic"}' -p /sensu
~~~
