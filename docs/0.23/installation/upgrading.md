---
version: 0.23
category: "Upgrading Guide"
title: "Upgrading Sensu"
weight: 8
---

# Upgrading Sensu

Upgrading Sensu is usually a straightforward process. In most cases, upgrading Sensu and/or Sensu Enterprise only requires upgrading to the latest package. Certain versions of Sensu may include changes that are *not backwards compatible* and require additional steps be taken when upgrading.

## Upgrading from Sensu < 0.17

The following documentation provides steps necessary when upgrading from a Sensu version < `0.17`.

### Stop Sensu services

The first step when upgrading Sensu from a release prior to 0.17 is stopping the Sensu services. All instances of `sensu-server` and `sensu-api` **MUST** be stopped before proceeding with the upgrade process.

For example:

~~~ shell
sudo service sensu-server stop
sudo service sensu-api stop
~~~

### Flush Redis

Sensu releases newer than 0.16 use a different Redis data structure, requiring Redis data to be flushed before upgrading.

The Redis CLI tool (`redis-cli`) can be used to issue the Redis command to flush the data currently stored in redis. Please run the following commands on your Redis server.

_NOTE: If your Redis server uses a password (`requirepass`) you will need to run the Redis command `AUTH your_redis_password` prior to running `FLUSHALL`._

~~~ shell
redis-cli
FLUSHALL
~~~

## Upgrading the Sensu package

The following instructions assume that you have already installed Sensu and/or Sensu Enterprise by using the steps detailed in the [Sensu Installation Guide](installation-overview).

_NOTE: If your machines do not have direct access to the internet and cannot reach the Sensu software repositories, you must mirror the repositories and keep them up-to-date._

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
