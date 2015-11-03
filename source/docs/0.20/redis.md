---
version: 0.20
category: "Reference Docs"
title: "Redis Configuration"
next:
  url: "ssl"
  text: "SSL Configuration"
---

# Overview

This reference document provides information to help you:

- Understand what Redis is
- Understand how Sensu uses Redis
- How to configure the Sensu Redis connection
- How to configure Redis
- How to secure Redis in production
- How to configure Redis for High Availability (HA)

# What is Redis?

Redis is a key-value database, which describes itself as “an open source, BSD licensed, advanced key-value cache and store”.

You can visit the official Redis website to learn more: [redis.io](http://redis.io/)

# How Sensu uses Redis

Sensu uses Redis for storing persistent data. When running Sensu Core, the Sensu server and API services (`sensu-server` and `sensu-api`) require access to Redis. When running Sensu Enterprise, only the Sensu Enterprise service (`sensu-enterprise`) requires access. All of the Sensu services for a given Sensu Core or Sensu Enterprise installation that require access to Redis **must use the same instance of Redis**, this includes distributed or HA Sensu Core and Sensu Enterprise configurations. Sensu uses Redis to store and access the Sensu client registry, check results, check execution history, and current event data.

# Anatomy of a Redis definition

The Redis definition uses the `"redis": {}` definition scope.

### Definition attributes

host
: description
  : The Redis instance hostname or IP address (recommended).
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
  : The Redis instance TCP port.
: required
  : false
: type
  : Integer
: default
  : `6379`
: example
  : ~~~ shell
    "port": 6380
    ~~~

password
: description
  : The Redis instance authentication password.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "password": "secret"
    ~~~

db
: description
  : The Redis instance DB to use/select (numeric index).
: required
  : false
: type
  : Integer
: default
  : `0`
: example
  : ~~~ shell
    "db": 1
    ~~~

auto_reconnect
: description
  : Reconnect to Redis in the event of a connection failure.
: required
  : false
: type
  : Boolean
: default
  : `true`
: example
  : ~~~ shell
    "auto_reconnect": false
    ~~~

reconnect_on_error
: description
  : Reconnect to Redis in the event of a Redis error, e.g. READONLY (not to be confused with a connection failure).
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "reconnect_on_error": true
    ~~~

# Configuring Redis

To configure Redis, please refer to the [official Redis configuration documentation](http://redis.io/topics/config).

# Security

Redis is designed to be accessed by trusted clients inside trusted environments. Access to the Redis TCP port (default is `6379`) should be limited, this can be accomplished with firewall rules (e.g. IPTables, EC2 security group). Redis does not support native SSL encryption, however, a SSL proxy like [Stunnel](https://www.stunnel.org/index.html) may be used to provide an encrypted tunnel, at the cost of added complexity. Redis does not provide access controls, however, it does support plain-text password authentication. Redis password authentication may be limited but it is recommended.

For more on Redis security, please refer to the [official Redis security documentation](http://redis.io/topics/security).

# Configuring Redis for High Availability (HA)

Redis supports asynchronous master-slave replication which allows one or more Redis servers to be exact copies of a master Redis server. Configuration of Redis master-slave replication is straightforward, requiring only a few steps beyond installation. For more information about Redis replication, please refer to the [official Redis replication documentation](http://redis.io/topics/replication).

## Redis master-slave replication

### Hardware requirements

Due to the performance characteristics of Redis as an in-memory key/value data store and Sensu's relatively small data set, the hardware requirements for Redis are relatively minimal. When provisioning a Redis server for Sensu it is important to use systems (e.g. virtual machines) with sufficient compute, memory, and network resources. Redis is a single threaded service, because of this it can only utilize a single CPU, so the quality of processor is more important than the quantity. In most cases Redis will be network bound so providing it with good network connectivity is most important. The `redis-benchmark` utility can be used to test the capabilities of Redis on a machine, please refer to the [official redis-benchmark documentation](http://redis.io/topics/benchmarks) for more information. Redis is a fast in-memory key/value data store and given enough resources it is unlikely to become a bottleneck for your Sensu installation.

### Install Redis

Before configuring Redis master-slave replication, Redis must first be installed on both servers. For Redis installation instructions, please refer to the [Sensu Redis installation guide](install-redis). Once Redis has been installed and started on both servers, you may proceed to configure Redis master-slave replication.

### Configure Redis master

A Redis server requires a few configuration changes before it is capable of becoming a Redis master. The Redis configuration file can be found at `/etc/redis/redis.conf` and can be edited by your preferred text editor with sudo privileges, e.g. `sudo nano /etc/redis/redis.conf`.

The Redis server must be configured to bind/listen on a network interface other than localhost (`127.0.0.1`). To allow external network connectivity (for slaves etc.), ensure that the `bind` configuration option is either commented out or modified to an appropriate network interface IP address.

~~~
#bind 127.0.0.1
~~~

Redis password authentication must be enabled, ensure that the `requirepass` and `masterauth` configuration options are uncommented and their values are the SAME complex string (for increased security), e.g. `thW0K5tB4URO5a9wsykBH8ja4AdwkQcw`.

~~~
requirepass your_redis_password
~~~

~~~
masterauth your_redis_password
~~~

Restart the Redis server to reload the now modified configuration.

#### Ubuntu/Debian

~~~ shell
sudo /etc/init.d/redis-server restart
~~~

#### CentOS/RHEL

~~~ shell
sudo /etc/init.d/redis restart
~~~

### Configure Redis slave

A Redis server requires a few configuration changes before it is capable of becoming a Redis slave. The Redis configuration file can be found at `/etc/redis/redis.conf` and can be edited by your preferred text editor with sudo privileges, e.g. `sudo nano /etc/redis/redis.conf`.

The Redis server must be configured to bind/listen on a network interface other than localhost (`127.0.0.1`). To allow external network connectivity, ensure that the `bind` configuration option is either commented out or modified to an appropriate network interface IP address.

~~~
#bind 127.0.0.1
~~~

Redis password authentication must be enabled, ensure that the `requirepass` configuration option is uncommented and its value is a complex string (for increased security). The Redis password string should match that of the Redis master.

~~~
requirepass your_redis_password
~~~

The Redis server must configured as a slave for a specific Redis master. To configure the Redis server as a slave, the `slaveof` configuration option must be uncommented and its value updated to point at the appropriate host address and Redis port for the Redis master. The default Redis port is `6379`.

~~~
slaveof your_redis_master_ip 6379
~~~

The Redis slave must be configured with the Redis master authentication password in order to connect to it. The `masterauth` configuration option must be uncommented and its value updated to equal the Redis master password (same value of `requirepass`).

~~~
masterauth your_redis_password
~~~

Restart the Redis server to reload the now modified configuration.

#### Ubuntu/Debian

~~~ shell
sudo /etc/init.d/redis-server restart
~~~

#### CentOS/RHEL

~~~ shell
sudo /etc/init.d/redis restart
~~~

### Verify master-slave replication

To verify that Redis master-slave replication has been configured correctly and that it is operating, the Redis CLI tool (`redis-cli`) can be used to issue Redis commands to query for information.

The following commands can be executed on both Redis servers, the master and the slave. The Redis command `INFO` provides replication status information.

~~~ shell
redis-cli
AUTH your_redis_password
INFO
~~~

Example `INFO` replication information:

~~~
...

# Replication
role:master
connected_slaves:1
slave0:ip=10.0.0.171,port=6379,state=online,offset=5475,lag=0
master_repl_offset:5475
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:2
repl_backlog_histlen:5474

...
~~~

## Redis Sentinel

Redis master-slave replication is able to produce one or more copies of a Redis server, however, it does not provide automatic failover between the master and slave Redis servers. Redis Sentinel is a service for managing Redis servers, capable of promoting a slave to master if the current master is not working as expected. Redis Sentinel can run on the same machines as Redis or on machines responsible for other services (preferred), such as RabbitMQ. At least three instances of Redis Sentinel are required for a robust deployment. For more information about Redis Sentinel, please refer to the [official Sentinel documentation](http://redis.io/topics/sentinel).
