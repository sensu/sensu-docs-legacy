---
title: "Redis Configuration"
description: "Reference documentation for configuring Redis for use with Sensu."
version: 0.26
weight: 16
next:
  url: "ssl"
  text: "SSL Configuration"
---

# Redis Configuration

## Reference documentation

- [What is Redis?](#what-is-redis)
- [How does Sensu use Redis?](#how-does-sensu-use-redis)
- [Install Redis](#install-redis)
- [Configure Sensu](#configure-sensu)
  - [Example configurations](#sensu-redis-configuration-examples)
  - [Redis definition specification](#redis-definition-specification)
    - [`redis` attributes](#redis-attributes)
    - [`sentinels` attributes](#sentinels-attributes)
- [Configure Redis](#sensu-redis-configuration)
  - [Standalone configuration](#redis-standalone-configuration)
  - [Distributed configuration](#redis-distributed-configuration)
  - [High Availability configuration](#redis-high-availability-configuration)
    - [What is Redis master-slave replication?](#what-is-redis-master-slave-replication)
    - [What is Redis Sentinel?](#what-is-redis-sentinel)
    - [High availability hardware requirements](#high-availability-hardware-requirements)
    - [Install Redis](#install-redis)
    - [Redis master-slave configuration](#redis-master-slave-configuration)
      - [Configure the Redis master](#configure-the-redis-master)
      - [Configure the Redis slave](#configure-the-redis-slave)
      - [Verify master-slave replication](#verify-master-slave-replication)
    - [Redis Sentinel configuration](#redis-sentinel-configuration)
      - [Configure a Sentinel](#configure-a-sentinel)
      - [Verify Redis Sentinel operation](#verify-redis-sentinel-operation)
    - [Configure Sensu to use Redis Sentinel](#configure-sensu-to-use-redis-sentinel)
- [Securing Redis](#securing-redis)

## What is Redis?

[Redis][1] is a key-value database, which describes itself as “an open source, BSD
licensed, advanced key-value cache and store”. Learn more at
[http://redis.io][1].

## How does Sensu uses Redis

Sensu uses Redis as a [data-store][2], for storing monitoring data (e.g. a
[client registry][3], current check results, current monitoring events, etc).
Only the [Sensu server][4] and [API][5] processes require access to Redis (i.e.
the `sensu-client` process does  not require access to Redis). **All Sensu
services in a cluster require access to the same instance (or cluster) of
Redis** (consequently, Redis does not need to  be installed on every system
where Sensu is installed).

Sensu also provides support for using Redis as a [transport][14]. Please see the
[Sensu transport reference documentation][14] for more information.

## Installing Redis

For more information about installing Redis for use with Sensu, please visit the
[Redis installation guide][6].

## Configure Sensu {#sensu-redis-configuration}

### Example configurations {#sensu-redis-configuration-examples}

The following are example Redis definitions at `/etc/sensu/conf.d/redis.json`.

_NOTE: if you are using Redis as your [Sensu transport][14], additional
configuration will need to be provided to tell Sensu to use Redis as the
transport instead of RabbitMQ (default); please see [transport configuration][15]
for more information._

#### Example standalone configuration {#sensu-redis-configuration-examples-standalone}

~~~ json
{
  "redis": {
    "host": "127.0.0.1",
    "port": 6379,
    "password": "secret"
  }
}
~~~

#### Example distributed configuration {#sensu-redis-configuration-examples-distributed}

~~~ json
{
  "redis": {
    "host": "10.0.1.23",
    "port": 6379,
    "password": "secret"
  }
}
~~~

#### Example high-availability configuration {#sensu-redis-configuration-examples-high-availability}

~~~ json
{
  "redis": {
    "password": "your_redis_password",
    "master": "redis-01",
    "sentinels": [
      {
        "host": "10.0.1.23",
        "port": 26379
      },
      {
        "host": "10.0.1.24",
        "port": 26379
      },
      {
        "host": "10.0.1.25",
        "port": 26379
      }
    ]
  }
}
~~~

### Redis definition specification

The Redis definition uses the `"redis": {}` definition scope.

#### `redis` attributes

`host`
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

    _WARNING: using `"localhost"` instead of `127.0.0.1` for the host
    configuration on systems that support IPv6 may result in an IPv6 "localhost"
    resolution (i.e. `::1`) rather than an IPv4 "localhost" resolution (i.e.
    `127.0.0.1`). Sensu does support
    IPv6, so this may be desirable; however, if Redis is not configured to listen on IPv6, this will
    result in a connection error and log entries indicating a `"redis connection
    error"` with an `"unable to connect to redis server"` error message._

`port`
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

`password`
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

`db`
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

`auto_reconnect`
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

`reconnect_on_error`
: description
  : Reconnect to Redis in the event of a Redis error, e.g. READONLY (not to be
    confused with a connection failure).
: required
  : false
: type
  : Boolean
: default
  : `true`
: example
  : ~~~ shell
    "reconnect_on_error": false
    ~~~

`master`
: description
  : The name of the Redis master set to connect to. Only used for
    [Redis Sentinel][16] connections.
    _WARNING: When configuring Sensu to use Sentinels for Redis failover, the
    value of this setting must match the configured name for the Redis master
    set. If these settings do not match, Sensu will be unable to connect to
    Redis._
: required
  : false
: default
  : `mymaster`
: type
  : String
: example
  : ~~~ shell
    "master": "redis-01"
    ~~~

`sentinels`
: description
  : Redis Sentinel configuration, connection information for one or more Redis
    Sentinel instances.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "sentinels": [{"host": "10.0.1.23", "port": 26379}]
    ~~~

#### `sentinels` attributes

The following attributes are configured within each item in `"sentinels": []`,
e.g. `"sentinels": [{"host": "10.0.1.23"}]`.

`host`
: description
  : The Redis Sentinel instance hostname or IP address (recommended).
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "host": "10.0.1.23"
    ~~~

`port`
: description
  : The Redis Sentinel instance TCP port.
: required
  : false
: type
  : Integer
: default
  : `26379`
: example
  : ~~~ shell
    "port": 26380
    ~~~

## Configure Redis

Please note the following configuration and tuning references for setting up
Redis with Sensu.

_NOTE: the Redis configuration documentation provided here is for convenience;
for a complete reference on configuring Redis, please refer to the [official
Redis configuration documentation][7]._

### Standalone configuration {#redis-standalone-configuration}

For standalone configurations, no additional Redis configuration changes are
required beyond what is documented in the [Redis installation guide][6].

### Distributed configuration {#redis-distributed-configuration}

For distributed configurations (e.g. where Redis is running on dedicated
systems), Redis may need to be configured to listen for connections from
external systems via the `bind` configuration directive.

To enable support for external connections, please ensure that your
`/etc/redis/redis.conf` file contains the following configuration snippet:

~~~ shell
# By default Redis listens for connections from all the network interfaces
# available on the server. It is possible to listen to just one or multiple
# interfaces using the "bind" configuration directive, followed by one or
# more IP addresses.
#
# Examples:
#
# bind 192.168.1.100 10.0.0.1
bind 0.0.0.0
~~~

### High-availability configuration {#redis-high-availability-configuration}

#### What is Redis master-slave replication?

Redis supports asynchronous master-slave replication which allows one or more
Redis servers to be exact copies of a "master" Redis server. Configuration of
Redis master-slave replication is fairly straightforward, requiring only a few
steps beyond installation. For more information about Redis replication, please
refer to the [official Redis replication documentation][8]. All Sensu components
that communicate with Redis must use the same instance of Redis, the current
Redis master.

#### What is Redis Sentinel?

Redis master-slave replication is able to produce one or more copies of a Redis
server, however, it does not provide automatic failover between the master and
slave Redis servers. Redis Sentinel is a service for managing Redis servers,
capable of promoting a slave to master if the current master is not working as
expected. Redis Sentinel is only available for Redis >= 2.8. Redis Sentinel can
run on the same machines as Redis or on machines responsible for other services
(preferred), such as RabbitMQ. Sentinel should be placed on machines that are
believed to fail in an independent way. At least three instances of Redis
Sentinel are required for a robust deployment. For more information about Redis
Sentinel, please refer to the [official Sentinel documentation][9]. The
following instructions will help you install and configure Redis Sentinel for
Sensu's Redis connectivity.

_NOTE: [Redis master-slave replication](#redis-master-slave-replication) must be
configured before configuring Sentinel._

#### High availability hardware requirements

Due to the performance characteristics of Redis as an in-memory key/value data
store and Sensu's relatively small data set, the hardware requirements for Redis
are relatively minimal. When provisioning a Redis server for Sensu it is
important to use systems (e.g. virtual machines) with sufficient compute,
memory, and network resources. Redis is a single threaded service, because of
this it can only utilize a single CPU, so the quality of processor is more
important than the quantity. In most cases Redis will be network bound so
providing it with good network connectivity is most important. The
`redis-benchmark` utility can be used to test the capabilities of Redis on a
machine, please refer to the [official redis-benchmark documentation][10] for
more information. Redis is a fast in-memory key/value data store and given
enough resources it is unlikely to become a bottleneck for your Sensu
installation.

For the best results when configuring Redis for high availability applications,
we recommend using two (2) systems for [Redis master-slave replication][12],
_and_ a minimum of three (3) [Redis Sentinels][13].

_NOTE: running fewer or more Redis Sentinels introduces additional failure
modes._

#### Install Redis

Before configuring [Redis master-slave replication][12] and [Redis
Sentinel][13], Redis must be installed on all of the systems you will use to
provide the Redis services. For Redis installation instructions, please refer to
the [Sensu Redis installation guide][11]. Once Redis has been installed and
started, you may proceed to configure Redis master-slave replication.

#### Redis master-slave configuration

##### Configure the Redis master

A Redis server requires a few configuration changes before it is capable of
becoming a Redis master. The Redis configuration file can be found at
`/etc/redis/redis.conf` and can be edited by your preferred text editor with
elevated privileges (e.g. `sudo nano /etc/redis/redis.conf`).

1. The Redis master server must be configured to bind/listen on a network
   interface other than localhost (`127.0.0.1`). To allow external network
   connectivity (for slaves etc.), ensure that the `bind` configuration option is
   either commented out or modified to an appropriate network interface IP
   address.

   ~~~
   #bind 127.0.0.1
   ~~~

2. Redis password authentication must be enabled, ensure that the `masterauth`
   and `requirepass` configuration options are uncommented and their values are
   the SAME complex string (for increased security) (e.g.
   `thW0K5tB4URO5a9wsykBH8ja4AdwkQcw`).

   ~~~
   masterauth your_redis_password
   ~~~

   ~~~
   requirepass your_redis_password
   ~~~

3. Restart the Redis server to reload the now modified configuration.

##### Configure the Redis slave

A Redis server requires a few configuration changes before it is capable of
becoming a Redis slave. The Redis configuration file can be found at
`/etc/redis/redis.conf` and can be edited by your preferred text editor with
sudo privileges, e.g. `sudo nano /etc/redis/redis.conf`.

1. The Redis server must be configured to bind/listen on a network interface
   other than localhost (`127.0.0.1`). To allow external network connectivity,
   ensure that the `bind` configuration option is either commented out or
   modified to an appropriate network interface IP address.

   ~~~
   #bind 127.0.0.1
   ~~~

2. Redis password authentication must be enabled, ensure that the `requirepass`
   configuration option is uncommented and its value is a complex string (for
   increased security). The Redis password string should match that of the Redis
   master.

   ~~~
   requirepass your_redis_password
   ~~~

3. The Redis server must configured as a slave for a specific Redis master. To
   configure the Redis server as a slave, the `slaveof` configuration option
   must be uncommented and its value updated to point at the appropriate host
   address and Redis port for the Redis master. The default Redis port is
   `6379`.

   ~~~
   slaveof your_redis_master_ip 6379
   ~~~

4. The Redis slave must be configured with the Redis master authentication password
   in order to connect to it. The `masterauth` configuration option must be
   uncommented and its value updated to equal the Redis master password (same value
   of `requirepass`).

   ~~~
   masterauth your_redis_password
   ~~~

5. Restart the Redis server to reload the now modified configuration.

##### Verify master-slave replication

To verify that Redis master-slave replication has been configured correctly and
that it is operating, the Redis CLI tool (`redis-cli`) can be used to issue
Redis commands to query for information.

The following commands can be executed on both Redis servers, the master and the
slave. The Redis command `AUTH` must first be used to authenticate with
`your_redis_password` before other commands can be used. The Redis command
`INFO` provides replication status information.

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


#### Redis Sentinel configuration

##### Configure a Sentinel

By default, Sentinel reads a configuration file that can be found at
`/etc/redis/sentinel.conf`. The Redis package may provide its own example
`sentinel.conf` file, however, the recommended configuration for Sensu is
provided as a downloadable configuration file.

_NOTE: At least three instances of Redis Sentinel are required for a robust
deployment._

1. Download the Sensu Redis Sentinel configuration file.

   ~~~ shell
   sudo wget -O /etc/redis/sentinel.conf http://sensuapp.org/docs/0.26/files/sentinel.conf
   ~~~

2. Sentinel not only reads its configuration from `/etc/redis/sentinel.conf`, but
   it also writes changes to it (state), so the Redis user must own the
   configuration file.

   ~~~ shell
   sudo chown redis:redis /etc/redis/sentinel.conf
   ~~~

3. The Redis Sentinel configuration file requires a few changes before Sentinel
   can be started. The Sentinel configuration file at `/etc/redis/sentinel.conf`
   can be edited by your preferred text editor with sudo privileges, e.g. `sudo
   nano /etc/redis/sentinel.conf`.

4. Sentinel needs to be pointed at the current Redis master server. Change
   `your_redis_master_ip` to the address that the Redis master server is
   listening on. Leaving the master name as `mymaster` is recommended, as many
   other configuration options reference it.

   ~~~
   sentinel monitor mymaster your_redis_master_ip 6379 2
   ~~~

5. Sentinel needs to know the Redis password, change `your_redis_password` to be
   the same value as `masterauth` (and `requirepass`) on the Redis master
   server.

   ~~~
   sentinel auth-pass mymaster your_redis_password
   ~~~

6. The Redis package does not provide an init script for Sentinel. Run the
   following command to install prereqs and download a working Redis Sentinel init script.

   Note that you may, on some RedHat variants, also need the `redhat-lsb` package to use this init script.

   ~~~ shell
   sudo yum install initscripts
   sudo wget -O /etc/init.d/redis-sentinel http://sensuapp.org/docs/0.26/files/redis-sentinel
   ~~~

   The Redis Sentinel init script file needs to be executable.

   ~~~ shell
   sudo chmod +x /etc/init.d/redis-sentinel
   ~~~

7. Enable the Redis Sentinel service on boot and start it:

##### Verify Redis Sentinel operation

To verify that Redis Sentinel has been configured correctly and that it is
operating, the Redis CLI tool (`redis-cli`) can be used to issue Redis commands
to Sentinel to query for information. The `redis-cli` command line argument `-p`
must be used to specify the Sentinel port (`26379`).

The following commands can be executed on any configured instance of Redis
Sentinel. The Redis command `INFO` provides the Sentinel information.

~~~ shell
redis-cli -p 26379
INFO
~~~

Example `INFO` Sentinel information:

~~~
...

# Sentinel
sentinel_masters:1
sentinel_tilt:0
sentinel_running_scripts:0
sentinel_scripts_queue_length:0
master0:name=mymaster,status=ok,address=10.0.0.214:6379,slaves=1,sentinels=3

...
~~~

#### Configuring Sensu for Redis Sentinel

Once Redis master-slave replication and Redis Sentinels have been configured,
it's time to configure Sensu. To configure the Sensu services that communicate
with Redis (e.g. `sensu-server`) to use the HA Redis configuration, they must be
configured to query Redis Sentinel for the current Redis master connection
information (host and port). The following is an example Sensu Redis
configuration snippet, located at `/etc/sensu/conf.d/redis.json`. The following
configuration could also be in `/etc/sensu/config.json`.

~~~ json
{
  "redis": {
    "password": "your_redis_password",
    "master": "mymaster",
    "sentinels": [
      {
        "host": "10.0.1.23",
        "port": 26379
      },
      {
        "host": "10.0.1.24",
        "port": 26379
      },
      {
        "host": "10.0.1.25",
        "port": 26379
      }
    ]
  }
}
~~~

## Securing Redis

Redis is designed to be accessed by trusted clients inside trusted environments.
Access to the Redis TCP port (default is `6379`) should be limited, this can be
accomplished with firewall rules (e.g. IPTables, EC2 security group). Redis does
not support native SSL encryption, however, a SSL proxy like
[Stunnel](https://www.stunnel.org/index.html) may be used to provide an
encrypted tunnel, at the cost of added complexity. Redis does not provide access
controls, however, it does support plain-text password authentication. Redis
password authentication may be limited but it is recommended.

For more on Redis security, please refer to the [official Redis security
documentation](http://redis.io/topics/security).


[1]:  http://redis.io/
[2]:  data-store.html
[3]:  clients.html#registration-and-registry
[4]:  server.html
[5]:  ../api/overview.html
[6]:  ../installation/install-redis.html
[7]:  http://redis.io/topics/config
[8]:  http://redis.io/topics/replication
[9]:  http://redis.io/topics/sentinel
[10]: http://redis.io/topics/benchmarks
[11]: ../installation/install-redis.html
[12]: #what-is-redis-master-slave-replication
[13]: #what-is-redis-sentinel
[14]: transport.html
[15]: transport.html#transport-configuration
[16]: http://redis.io/topics/sentinel#a-quick-tutorial
