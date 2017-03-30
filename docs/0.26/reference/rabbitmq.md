---
title: "RabbitMQ Configuration"
description: "Reference documentation for configuring RabbitMQ for use with
  Sensu."
version: 0.26
weight: 15
---

# RabbitMQ Configuration

## Reference documentation

- [What is RabbitMQ?](#what-is-rabbitmq)
- [How does Sensu use RabbitMQ?](#how-does-sensu-use-rabbitmq)
- [Install RabbitMQ](#install-rabbitmq)
- [Configure Sensu](#sensu-rabbitmq-configuration)
  - [Example configuraitons](#sensu-rabbitmq-configuration-examples)
  - [RabbitMQ definition specificaiton](#rabbitmq-definition-specification)
    - [`rabbitmq` attributes](#rabbitmq-attributes)
    - [`ssl` attributes](#ssl-attributes)
- [Configure RabbitMQ](#configure-rabbitmq)
  - [Standalone configuration](#standalone-configuration)
  - [Distributed configuration](#distributed-configuration)
  - [High-availability configuration](#high-availability-configuration)
    - [What is a RabbitMQ cluster?](#what-is-a-rabbitmq-cluster)
    - [High availability hardware requirements](#high-availability-hardware-requirements)
    - [Install RabbitMQ](#install-rabbitmq)
    - [Configure a RabbitMQ cluster](#configure-a-rabbitmq-cluster)
    - [Configure Sensu to use the RabbitMQ cluster](#configure-sensu-to-use-the-rabbitmq-cluster)
- [Securing RabbitMQ](#securing-rabbitmq)
  - [RabbitMQ and SELinux](#rabbitmq-and-selinux)
  - [RabbitMQ SSL](#rabbitmq-ssl)
  - [RabbitMQ SSL and Erlang 18.3](#rabbitmq-ssl-and-erlang-183)

## What is RabbitMQ?

RabbitMQ is a message bus, which [describes itself][1] as _"a messaging broker -
an intermediary for messaging. It gives your applications a common platform to
send and receive messages, and your messages a safe place to live until
received"_.

To learn more about RabbitmQ, please visit [the official RabbitMQ website][2].

## How does Sensu use RabbitMQ?

Sensu services use RabbitMQ (the default [Sensu transport][3]) to communicate
with one another. Every Sensu service requires access to the same instance of
RabbitMQ or a RabbitMQ cluster to function. Sensu check requests and check
results are sent over RabbitMQ to the approprate Sensu services.

## Install RabbitMQ

For more information about installing RabbitMQ for use with Sensu, please visit
the [RabbitMQ installation guide][5].

## Configure Sensu {#sensu-rabbitmq-configuration}

### Example configurations {#sensu-rabbitmq-configuration-examples}

The following are an example RabbitMQ connection definitions, each located at
`/etc/sensu/conf.d/rabbitmq.json`.

#### Example standalone configuration {#sensu-rabbitmq-configuration-examples-standalone}

~~~ json
{
  "rabbitmq": {
    "host": "127.0.0.1",
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

#### Example distributed configuration {#sensu-rabbitmq-configuration-examples-distributed}

~~~ json
{
  "rabbitmq": {
    "host": "10.0.1.6",
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

#### Example high-availability configuration {#sensu-rabbitmq-configuration-examples-high-availability}

~~~ json
{
  "rabbitmq": [
    {
      "host": "10.0.0.6",
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
      "host": "10.0.0.7",
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
      "host": "10.0.0.8",
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

### RabbitMQ definition specification

The RabbitMQ definition uses the `"rabbitmq": {}` definition scope.

#### `rabbitmq` attributes

`host`
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

`port`
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

`vhost`
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

`user`
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

`password`
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

`heartbeat`
: description
  : The RabbitMQ AMQP connection heartbeat in seconds.  Enabling can help in
    early detection of disrupted TCP connections causing the RabbitMQ client to
    attempt re-connection to the server much earlier than if left disabled.
    _NOTE: if this setting is not defined or set to 0 then RabbitMQ client
    heartbeats are disabled.
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "heartbeat": 30
    ~~~

`prefetch`
: description
  : The RabbitMQ AMQP consumer prefetch value, setting the number of
    unacknowledged messages allowed for the channel. This attribute can be used
    as a flow control mechanism, to tune message throughput performance.
    _NOTE: an increased prefetch value should be used if you are experiencing a
    backlog of messages in RabbitMQ while the Sensu server(s) load remains low.
    Increasing the prefetch value will effect the distribution of messages in
    Sensu configurations with more than one Sensu server._
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

`ssl`
: description
  : A set of attributes that configure SSL encryption for the connection. SSL
    encryption will be enabled if this attribute is configured.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "ssl": {}
    ~~~

#### `ssl` attributes

The following attributes are configured within the `"ssl": {}` RabbitMQ
definition attribute scope.

`cert_chain_file`
: description
  : The file path for the chain of X509 SSL certificates in the PEM format for
    the SSL connection.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "cert_chain_file": "/etc/sensu/ssl/cert.pem"
    ~~~

`private_key_file`
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

## Configure RabbitMQ

To configure RabbitMQ, please refer to the [official RabbitMQ configuration
documentation][4].

### Standalone configuration

For standalone configurations, no additional configuration changes are required
beyond what is documented in the [RabbitMQ installation guide][5].

### Distributed configuration

For distributed configurations (e.g. where RabbitMQ is running on dedicated
systems), RabbitMQ may need to be configure to listen for connections from
external systems using the [`tcp_listeners` configuration directive][6].

To enable support for external connections, please ensure that your
`/etc/rabbitmq/rabbitmq.config` file contains the following configuration
snippet:

~~~ shell
[
  {rabbit, [
    {tcp_listeners, [{"0.0.0.0", 5672}]}
  ]}
].
~~~

### High-availability configuration

#### What is a RabbitMQ cluster?

RabbitMQ supports grouping of several RabbitMQ servers into a cluster. [The
official RabbitMQ clustering documentation][7] describes clusters as follows:

> A RabbitMQ broker is a logical grouping of one or several Erlang nodes, each
  running the RabbitMQ application and sharing users, virtual hosts, queues,
  exchanges, bindings, and runtime parameters. Sometimes we refer to the
  collection of nodes as a cluster.

In high availability configurations, all of the Sensu processes need to be able
to communicate with a member of a single RabbitMQ cluster.

#### High-availability hardware requirements

The Sensu transport does not require message persistence, making throughput the
primary concern for RabbitMQ (i.e. memory is more important than disk
performance). When starting with a RabbitMQ cluster it is important to use
systems with sufficient compute, memory, and network resources. Although it's
challenging to provide "recommended hardware requirements" for every possible
Sensu installation, we have found that starting with three nodes equivalent to
[AWS EC2 m3.medium instances][8] generally provides a solid baseline for
monitoring 1000+ servers, each reporting 10-20 checks (& metrics) at a 10-second
interval.

For the best results when configuring RabbitMQ for high availability
applications, we recommend a three (3) node RabbitMQ cluster, as running fewer
or more nodes introduces additional failure modes.

#### Install RabbitMQ

Before configuring a RabbitMQ cluster, RabbitMQ must be installed on all of the
systems you will use to provide the RabbitMQ services. For RabbitMQ installation
instructions, please refer to the [Sensu RabbitMQ installation guide][5]. Once
RabbitMQ has been installed and started, you may proceed to configure the
RabbitMQ cluster.

#### Configure a RabbitMQ cluster

While much of the configuration for RabbitMQ lives in [a configuration file
located at `/etc/rabbitmq/rabbitmq.config`][9], some things do not mesh well with
the use of a configuration file. RabbitMQ calls these items ["runtime parameters
and policies"][10], which are defined using the [`rabbitmqctl`][11] utility. For
more information on configuring RabbitMQ, please visit the [official RabbitMQ
configuration documentation][4].

To configure your three node RabbitMQ cluster for use with Sensu, please note
the following instructions:

1. Stop the RabbitMQ service on all three RabbitMQ systems.

   _NOTE: The `service` command will not work on CentOS 5, the
   sysvinit script must be used, e.g. `sudo /etc/init.d/rabbitmq-server stop`_

   ~~~ shell
   sudo service rabbitmq-server stop
   ~~~

2. Enable RabbitMQ [`pause_minority` network partition handling][12]. Please
   ensure that your `/etc/rabbitmq/rabbitmq.config` configuration file contains
   the following configuration snippet:

   ~~~ erlang
   [
     {rabbit, [
       {cluster_partition_handling, pause_minority}
     ]}
   ].
   ~~~

   _NOTE: a RabbitMQ cluster offers several methods of handling network
   partitions. A RabbitMQ cluster should not span regions (e.g. WAN links), as
   doing so would increase latency and the probability of network partitions._

3. Set the RabbitMQ erlang cookie on all 3 selected instances to the same value
   (e.g. `cookiemonster`). Create and/or edit the file located at
   `/var/lib/rabbitmq/.erlang.cookie` so that it contains the following
   contents:

   ~~~
   coookiemonster
   ~~~

   _WARNING: if this file is edited while RabbitMQ is running it may prevent the
   RabbitMQ process from stopping and/or restarting gracefully, which is why
   step #1 of these instructions indicates that the RabbitMQ services should be
   stopped before making configuration changes._

4. Start RabbitMQ on all three RabbitMQ systems.

   _NOTE: The `service` command will not work on CentOS 5, the
   sysvinit script must be used, e.g. `sudo /etc/init.d/rabbitmq-server start`_

   ~~~ shell
   sudo service rabbitmq-server start
   ~~~

5. Reset the RabbitMQ nodes on all 3 selected instances in preparation for
   clustering.

   ~~~ shell
   sudo rabbitmqctl stop_app
   sudo rabbitmqctl reset
   ~~~

6. Start the RabbitMQ application on **one of the three RabbitMQ systems**, and
   obtain the IP address of this system for instructing the remaining systems on
   where to join the RabbitMQ cluster.

   ~~~ shell
   sudo rabbitmqctl start_app
   ifconfig
   ~~~

   _NOTE: this step effectively starts the RabbitMQ "cluster", which the other
   RabbitMQ systems will join in the following steps. for the purposes of this
   guide we will assume `10.0.1.6` is the IP address of this system._

7. Join the other two RabbitMQ systems to the RabbitMQ cluster started in step
   #6 using the `rabbitmqctl` utility, and the IP address obtained in step #6.

   ~~~ shell
   sudo rabbitmqctl join_cluster rabbit@ip-10-0-1-6
   sudo rabbitmqctl start_app
   ~~~

   _NOTE: these commands need to be run twice - once on each of the remaining
   two RabbitMQ systems in the cluster._

   _WARNING: when adding a RabbitMQ broker to a cluster (e.g. `rabbitmqctl
   join_cluster rabbit@hostname`, the brokers must be able to successfully
   resolve each other's `hostname`._

8. Add the Sensu `vhost` and `user` credentials from any system in the new
   RabbitMQ cluster.

   ~~~ shell
   sudo rabbitmqctl add_vhost /sensu
   sudo rabbitmqctl add_user sensu secret
   sudo rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
   sudo rabbitmqctl list_permissions -p /sensu
   ~~~

   _NOTE: please replace `secret` with your desired password. These `vhost` and
   `user` credentials will be automatically replicated to the other instances in
   the RabbitMQ cluster._

9. Create a RabbitMQ policy to enable high-availability for Sensu's `result` and
   `keepalive` queues:

   ~~~ shell
   sudo rabbitmqctl set_policy ha-sensu "^(results$|keepalives$)" '{"ha-mode":"all", "ha-sync-mode":"automatic"}' -p /sensu
   sudo rabbitmqctl list_policies -p /sensu
   ~~~

   _NOTE: by default, queues within a RabbitMQ cluster are located on a single
   node (the node on which they were first declared). This is in contrast to
   exchanges and bindings, which can always be considered to be on all nodes in
   a RabbitMQ cluster. Sensu requires specific queues to be mirrored across all
   RabbitMQ nodes in a RabbitMQ cluster. The Sensu `results` and `keepalives`
   queues **MUST** be mirrored. Sensu client subscription queues do not need to
   be mirrored._

   _WARNING: RabbitMQ uses policies to determine which queues are mirrored. The
   command provided above will create a RabbitMQ policy to mirror the Sensu
   `results` and `keealives` queues in the RabbitMQ `vhost` named `/sensu`. If
   you have modified your configuration to use a `vhost` other than `/sensu`,
   please proceed accordingly._

#### Configure Sensu to use the RabbitMQ cluster

Sensu services (e.g. `sensu-client`) can be configured with the connection
information for each RabbitMQ node in a RabbitMQ cluster without the need for
load-balancing middleware (e.g. HAProxy). Sensu will randomly sort the
configured RabbitMQ connections and attempt to connect to one of the nodes in
the cluster. If Sensu is unable to connect to a node in a RabbitMQ cluster, or
if Sensu loses connectivity to a node in a RabbitMQ cluster, it will attempt to
connect (or reconnect) to the next node in the RabbitMQ cluster.

To configure Sensu to connect to a RabbitMQ cluster, the `"rabbitmq"`
configuration Hash can be replaced with an Array of RabbitMQ connection
configurations (i.e. `"rabbitmq": []` instead of `"rabbitmq": {}`).

The following is an example [RabbitMQ definition][13] that configures Sensu to
connect to a RabbitMQ cluster.

_NOTE: the RabbitMQ nodes must first be successfully clustered in order for
Sensu to operate._

~~~ json
{
  "rabbitmq": [
    {
      "host": "10.0.0.1",
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
      "host": "10.0.0.2",
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
      "host": "10.0.0.3",
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

## Securing RabbitMQ

Sensu leverages RabbitMQ access control and SSL for secure communication. Sensu
was created to deal with dynamic infrastructure, where it is not feasible to
maintain strict firewall rules. It is common to expose RabbitMQ’s SSL port
(`5671`) without any restrictions, if certain conditions are met. Removing the
default RabbitMQ user `guest` is mandatory and using a generated user name,
password, and vhost is highly recommended. Enabling SSL peer certificate
verification will ensure only trusted RabbitMQ clients with the correct private
key are able to connect.

### RabbitMQ and SELinux

If SELinux is enabled on the machine(s) reponsible for running RabbitMQ, you may
need to make minor policy changes in order for RabbitMQ (and Erlang) to run
successfully.

To list the available SELinux booleans, run the following command:

~~~ shell
sudo getsebool -a
~~~

For some reason, enabling the NIS boolean allows RabbitMQ to bind to its TCP
socket and operate normally.

~~~ shell
sudo setsebool -P nis_enabled 1
~~~

### RabbitMQ SSL

For more information on configuring RabbitMQ to use SSL, please visit the [Sensu
SSL documentation][14].

### RabbitMQ SSL and Erlang 18.3

For users of Erlang version 18.3, the SSL implementation that RabbitMQ relies on
changed in such a way that additional configuration parameters are needed for
SSL encrypted communication between Sensu and RabbitMQ (specifically affecting
Sensu Enterprise users). This does not apply to Erlang 19.0+

In order to enable SSL communication between RabbitMQ installations running on
Erlang 18.3 and Sensu, it is necessary to configure the specific TLS version
(i.e. `{versions, ['tlsv1.2']}`) and ciphers (i.e. `{ciphers,
[{rsa,aes_256_cbc,sha256}]}`) that RabbitMQ will accept, and to reject clients
with no certificate (i.e. `{fail_if_no_peer_cert,true}`).

~~~ shell
[
 {rabbit, [
    {ssl_listeners, [5671]},
    {ssl_options, [{cacertfile,"/etc/rabbitmq/ssl/cacert.pem"},
                   {certfile,"/etc/rabbitmq/ssl/cert.pem"},
                   {keyfile,"/etc/rabbitmq/ssl/key.pem"},
                   {versions, ['tlsv1.2']},
                   {ciphers,  [{rsa,aes_256_cbc,sha256}]},
                   {verify,verify_peer},
                   {fail_if_no_peer_cert,true}]}
  ]}
].
~~~

_WARNING: if you are seeing RabbitMQ log entries with messages like `Fatal
error: insufficient security`, and using Erlang 18.3, please confirm that
the above stated configuration changes are in place._

[1]:  http://www.rabbitmq.com/features.html
[2]:  http://www.rabbitmq.com/
[3]:  transport.html
[4]:  https://www.rabbitmq.com/configure.html
[5]:  ../installation/install-rabbitmq.html
[6]:  https://www.rabbitmq.com/networking.html#interfaces
[7]:  https://www.rabbitmq.com/clustering.html
[8]:  http://aws.amazon.com/ec2/instance-types/#M3
[9]:  https://www.rabbitmq.com/configure.html#configuration-file
[10]: https://www.rabbitmq.com/parameters.html
[11]: https://www.rabbitmq.com/man/rabbitmqctl.1.man.html
[12]: https://www.rabbitmq.com/partitions.html#automatic-handling
[13]: #rabbitmq-definition-specification
[14]: ssl.html
