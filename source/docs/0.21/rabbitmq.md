---
version: 0.21
category: "Reference Docs"
title: "RabbitMQ Configuration"
next:
  url: "redis"
  text: "Redis Configuration"
---

# Overview

This reference document provides information to help you:

- [Understand what RabbitMQ is](#what-is-rabbitmq)
- [Understand how Sensu uses RabbitMQ](#how-sensu-uses-rabbitmq)
- [How to configure the Sensu RabbitMQ connection](#anatomy-of-a-rabbitmq-definition)
- [How to configure RabbitMQ](#configuring-rabbitmq)
- [How to secure RabbitMQ in production](#security)
- [How to configure RabbitMQ for High Availability (HA)](#configuring-rabbitmq-for-high-availability-ha)

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
  : The RabbitMQ AMQP consumer prefetch value, setting the number of unacknowledged messages allowed for the channel. This attribute can be used as a flow control mechanism, to tune message throughput performance. _NOTE: an increased prefetch value should be used if you are experiencing a backlog of messages in RabbitMQ while the Sensu server(s) load remains low. Increasing the prefetch value will effect the distribution of messages in Sensu configurations with more than one Sensu server._
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
  : A set of attributes that configure SSL encryption for the connection. SSL encryption will be enabled if this attribute is configured.
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

### Example RabbitMQ definition

The following is an example RabbitMQ connection definition at `/etc/sensu/conf.d/rabbitmq.json`.

~~~ json
{
  "rabbitmq": {
    "host": "57.43.53.42",
    "port": 5671,
    "vhost": "/sensu",
    "user": "sensu",
    "password": "secret",
    "heartbeat": 30,
    "prefetch": 50,
    "ssl": {
      "cert_chain_file": "/etc/sensu/ssl/cert.pem",
      "private_key_file": "/etc/sensu/ssl/key.pem"
    }
  }
}
~~~

# Configuring RabbitMQ

To configure RabbitMQ, please refer to the [official RabbitMQ configuration documentation](https://www.rabbitmq.com/configure.html).

# Security

Sensu leverages RabbitMQ access control and SSL for secure communication. Sensu was created to deal with dynamic infrastructure, where it is not feasible to maintain strict firewall rules. It is common to expose RabbitMQ’s SSL port (`5671`) without any restrictions, if certain conditions are met. Removing the default RabbitMQ user `guest` is mandatory and using a generated user name, password, and vhost is highly recommended. Enabling SSL peer certificate verification will ensure only trusted RabbitMQ clients with the correct private key are able to connect.

## SELinux

If SELinux is enabled on the machine(s) reponsible for running RabbitMQ, you may need to make minor policy changes in order for RabbitMQ (and Erlang) to run successfully.

To list the available SELinux booleans, run the following command:

~~~ shell
sudo getsebool -a
~~~

For some reason, enabling the NIS boolean allows RabbitMQ to bind to its TCP socket and operate normally.

~~~ shell
sudo setsebool -P nis_enabled 1
~~~

# Configuring RabbitMQ for High Availability (HA)

For the best results when configuring HA RabbitMQ, we recommend reading the following information and instructions. Running a three node RabbitMQ cluster is recommended, as running fewer or more nodes introduces additional failure modes.

## Configure a three node RabbitMQ cluster

### Hardware requirements

The Sensu transport does not require message persistence, making throughput the primary concern for RabbitMQ (i.e. memory is more important than disk performance). When starting with a RabbitMQ cluster it is important to use systems (e.g. virtual machines) with sufficient compute, memory, and network resources. Although it's challenging to provide "recommended hardware requirements" for the broad variety of Sensu deployments, we have found that starting with three nodes equivalent to [AWS EC2 m3.medium instances](http://aws.amazon.com/ec2/instance-types/#M3) generally provides a solid baseline for monitoring 1000+ servers, each reporting 10-20 checks (& metrics) at a 10-second interval.

### RabbitMQ cluster configuration

When configuring a RabbitMQ cluster, the recommended method is via the `rabbitmqctl` CLI tool provided by the RabbitMQ package. For more information on this method of clustering RabbitMQ, please refer to the [official RabbitMQ clustering guide](https://www.rabbitmq.com/clustering.html).

_NOTE: An essential configuration step that is commonly skipped is the management of the Erlang cookie that RabbitMQ nodes in a cluster must share (same). The cookie will be typically located in `/var/lib/rabbitmq/.erlang.cookie`._

_NOTE: When adding a RabbitMQ broker to a cluster, e.g. `rabbitmqctl join_cluster rabbit@rabbit1`, the brokers must be able to successfully resolve each other's hostname (e.g. `rabbit1`)._

A RabbitMQ cluster offers several methods of handling network partitions. A RabbitMQ cluster should not span regions (e.g. WAN links), as doing so would increase latency and the probability of network partitions. The recommended network partition handling mode for a three node RabbitMQ cluster is [pause_minority](https://www.rabbitmq.com/partitions.html#pause-minority). The [pause_minority](https://www.rabbitmq.com/partitions.html#pause-minority) mode will cause the RabbitMQ node(s) in the partition minority to pause, triggering connected clients to reconnect to a "healthy" node in the partition majority.

The following is a portion of a `/etc/rabbitmq/rabbitmq.config` configuration file, which configures RabbitMQ to use the `pause_minority` network partition handling mode when the RabbitMQ cluster experiences a network partition (and/or connectivity issues). For more information about `rabbitmq.config`, please refer to the [official RabbitMQ configuration file documentation](https://www.rabbitmq.com/configure.html#configuration-file).

~~~ erlang
[
  {rabbit, [
    {cluster_partition_handling, pause_minority},
    ...
  ]}
].
~~~

### Mirroring the Sensu queues

By default, queues within a RabbitMQ cluster are located on a single node (the node on which they were first declared). This is in contrast to exchanges and bindings, which can always be considered to be on all nodes. Sensu requires specific queues be mirrored across all RabbitMQ nodes in the RabbitMQ cluster. The Sensu `results` and `keepalives` queues MUST be mirrored. Sensu client subscription queues do not need to be mirrored.

RabbitMQ uses policies to determine which queues are mirrored. The following will create a RabbitMQ policy to mirror the Sensu `results` and `keealives` queues in the `/sensu` vhost (documentation default).

~~~
sudo rabbitmqctl set_policy ha-sensu "^(results$|keepalives$)" '{"ha-mode":"all", "ha-sync-mode":"automatic"}' -p /sensu
~~~

_NOTE: RabbitMQ cluster configuration will remove existing vhost and user configuration, these will need to be reconfigured following the initial [RabbitMQ installation guide](install-rabbitmq#configure-rabbitmq)._


### Configuring Sensu for a RabbitMQ cluster

Sensu services (e.g. `sensu-client`) can be configured with the connection information for each RabbitMQ node in a RabbitMQ cluster. Sensu will randomly sort the configured RabbitMQ connections and attempt to connect to one of them. If Sensu is unable to connect to a RabbitMQ node in a cluster, or looses connectivity (reconnect), it will attempt to connect to the next RabbitMQ node in the cluster. Having Sensu be aware of all RabbitMQ nodes in a cluster is essential and removes any need for a load balancer etc.

To configure Sensu to connect to RabbitMQ nodes in a cluster, the `"rabbitmq"` scope can be provided with an array of RabbitMQ connection configurations, e.g. `"rabbitmq": []`.

The following is an example RabbitMQ definition that configures Sensu to connect to a RabbitMQ cluster.

_NOTE: the RabbitMQ nodes must first be successfully clustered in order for Sensu to operate._

~~~ json
{
  "rabbitmq": [
    {
      "host": "57.43.53.42",
      "port": 5671,
      "vhost": "/sensu",
      "user": "sensu",
      "password": "secret",
      "heartbeat": 30,
      "prefetch": 50,
      "ssl": {
        "cert_chain_file": "/etc/sensu/ssl/cert.pem",
        "private_key_file": "/etc/sensu/ssl/key.pem"
      }
    },
    {
      "host": "57.43.53.43",
      "port": 5671,
      "vhost": "/sensu",
      "user": "sensu",
      "password": "secret",
      "heartbeat": 30,
      "prefetch": 50,
      "ssl": {
        "cert_chain_file": "/etc/sensu/ssl/cert.pem",
        "private_key_file": "/etc/sensu/ssl/key.pem"
      }
    },
    {
      "host": "57.43.53.44",
      "port": 5671,
      "vhost": "/sensu",
      "user": "sensu",
      "password": "secret",
      "heartbeat": 30,
      "prefetch": 50,
      "ssl": {
        "cert_chain_file": "/etc/sensu/ssl/cert.pem",
        "private_key_file": "/etc/sensu/ssl/key.pem"
      }
    }
  ]
}
~~~