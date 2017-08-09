---
version: 0.27
category: "Upgrading Guide"
title: "Upgrading Sensu"
weight: 8
---

# Upgrading Sensu

Upgrading Sensu is usually a straightforward process. In most cases,
upgrading Sensu and/or Sensu Enterprise only requires upgrading to the
latest package. Certain versions of Sensu may include changes that are
*not backwards compatible* and require additional steps be taken when
upgrading.

## Upgrading from Sensu < 0.27

The following documentation provides steps necessary when upgrading
from a Sensu version < `0.27`.

### Stop Sensu services

The first step when upgrading Sensu from a release prior to 0.27 is
stopping the Sensu services. All instances of `sensu-client`,
`sensu-server` and `sensu-api` **MUST** be stopped before proceeding
with the upgrade process.

For example:

~~~ shell
sudo service sensu-server stop
sudo service sensu-api stop
~~~

Stopping services prior to upgrading from a Sensu version < `0.27`
helps to avoid service management errors related to the transition
from sysv init scripts to systemd unit files on platforms like Debian
8, Ubuntu 16.04 and Centos 7 or newer.

### Update environment variables

As of Sensu 0.27 and later, the `CONFIG_DIR` environment variable has been
renamed to `CONFD_DIR`.

If you have customized your Sensu installation using this environment variable,
you may need to update one or more of the following files to reflect the change:

  *  `/etc/default/sensu`
  *  `/etc/default/sensu-server`
  *  `/etc/default/sensu-client`
  *  `/etc/default/sensu-api`
  *  `/etc/default/sensu-enterprise`

### TLS/SSL changes

When upgrading to Sensu 0.27 or later, please note that the OpenSSL libraries
included in Sensu's embedded Ruby environment have been upgraded from 1.0.1t to
1.0.2k. OpenSSL team ended support for 1.0.1 at the end of 2016, and plans to
support 1.0.2 through 2019. See OpenSSL's published [release
strategy][openssl-release-strat] for more detail.

Although this OpenSSL version change appears minor, it has been reported by some
that upgraded Sensu processes are unable negotiate secure connections with their
RabbitMQ brokers after upgrading. In many cases we find this is due to RabbitMQ
running on old versions of Erlang (e.g. R16B03) which have known issues around
TLS/SSL negotiation.

When upgrading from Sensu < 0.27 to 0.27 or later, please review the [RabbitMQ
"Which Erlang?" guidelines][which-erlang] and compare these recommendations to
your deployed RabbitMQ infrastructure. In brief, these guidelines specify Erlang
17 or newer for reliable TLS/SSL operation, and recommend Erlang 19.2 where
possible.

## Upgrading from Sensu < 0.17

The following documentation provides steps necessary when upgrading
from a Sensu version < `0.17`.

### Stop Sensu services

The first step when upgrading Sensu from a release prior to 0.17 is
stopping the Sensu services. All instances of `sensu-server` and
`sensu-api` **MUST** be stopped before proceeding with the upgrade
process.

For example:

~~~ shell
sudo service sensu-server stop
sudo service sensu-api stop
~~~

### Flush Redis

Sensu releases newer than 0.16 use a different Redis data structure,
requiring Redis data to be flushed before upgrading.

The Redis CLI tool (`redis-cli`) can be used to issue the Redis
command to flush the data currently stored in redis. Please run the
following commands on your Redis server.

_NOTE: If your Redis server uses a password (`requirepass`) you will
need to run the Redis command `AUTH your_redis_password` prior to
running `FLUSHALL`._

~~~ shell
redis-cli
FLUSHALL
~~~

## Upgrading the Sensu package

The following instructions assume that you have already installed
Sensu and/or Sensu Enterprise by using the steps detailed in the
[Sensu Installation Guide](installation-overview).

_NOTE: If your machines do not have direct access to the internet and
cannot reach the Sensu software repositories, you must mirror the
repositories and keep them up-to-date._

### Sensu Core

#### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get -y install sensu
~~~

#### CentOS/RHEL

~~~ shell
sudo yum install sensu
~~~

### Sensu Enterprise

#### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get -y install sensu-enterprise
~~~

#### CentOS/RHEL

~~~ shell
sudo yum install sensu-enterprise
~~~

### Sensu Enterprise Dashboard

#### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get -y install sensu-enterprise-dashboard
~~~

#### CentOS/RHEL

~~~ shell
sudo yum install sensu-enterprise-dashboard
~~~

[openssl-release-strat]: https://www.openssl.org/policies/releasestrat.html
[which-erlang]: https://www.rabbitmq.com/which-erlang.html
