---
version: 0.21
category: "Reference Docs"
title: "Redis Configuration"
next:
  url: "ssl"
  text: "SSL Configuration"
---

# Overview

This reference document provides information to help you:

- [Understand what Redis is](#what-is-redis)
- [Understand how Sensu uses Redis](#how-sensu-uses-redis)
- [How to configure the Sensu Redis connection](#anatomy-of-a-redis-definition)
- [How to configure Redis](#configuring-redis)
- [How to secure Redis in production](#security)
- [How to configure Redis for High Availability (HA)](#configuring-redis-for-high-availability-ha)

# What is Redis?

Redis is a key-value database, which describes itself as “an open source, BSD licensed, advanced key-value cache and store”.

You can visit the official Redis website to learn more: [redis.io](http://redis.io/)

# How Sensu uses Redis

Sensu uses Redis for storing persistent data (e.g. current events). When running Sensu Core, the Sensu server and API services (`sensu-server` and `sensu-api`) require access to Redis. When running Sensu Enterprise, only the Sensu Enterprise service (`sensu-enterprise`) requires access. All of the Sensu services for a given Sensu Core or Sensu Enterprise installation that require access to Redis **must use the same instance of Redis**, this includes distributed or HA Sensu Core and Sensu Enterprise configurations. Sensu uses Redis to store and access the Sensu client registry, check results, check execution history, and current event data.

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

### Example Redis definition

The following is an example Redis connection definition at `/etc/sensu/conf.d/redis.json`.

~~~ json
{
  "redis": {
    "host": "57.43.53.37",
    "port": 6379,
    "password": "secret"
  }
}
~~~

# Configuring Redis

To configure Redis, please refer to the [official Redis configuration documentation](http://redis.io/topics/config).

# Security

Redis is designed to be accessed by trusted clients inside trusted environments. Access to the Redis TCP port (default is `6379`) should be limited, this can be accomplished with firewall rules (e.g. IPTables, EC2 security group). Redis does not support native SSL encryption, however, a SSL proxy like [Stunnel](https://www.stunnel.org/index.html) may be used to provide an encrypted tunnel, at the cost of added complexity. Redis does not provide access controls, however, it does support plain-text password authentication. Redis password authentication may be limited but it is recommended.

For more on Redis security, please refer to the [official Redis security documentation](http://redis.io/topics/security).

# Configuring Redis for High Availability (HA)

Redis supports asynchronous master-slave replication which allows one or more Redis servers to be exact copies of a master Redis server. Configuration of Redis master-slave replication is straightforward, requiring only a few steps beyond installation. For more information about Redis replication, please refer to the [official Redis replication documentation](http://redis.io/topics/replication). All Sensu components that communicate with Redis must use the same instance of Redis, the current Redis master.

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

Redis password authentication must be enabled, ensure that the `masterauth` and `requirepass` configuration options are uncommented and their values are the SAME complex string (for increased security), e.g. `thW0K5tB4URO5a9wsykBH8ja4AdwkQcw`.

~~~
masterauth your_redis_password
~~~

~~~
requirepass your_redis_password
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

The following commands can be executed on both Redis servers, the master and the slave. The Redis command `AUTH` must first be used to authenticate with `your_redis_password` before other commands can be used. The Redis command `INFO` provides replication status information.

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

Redis master-slave replication is able to produce one or more copies of a Redis server, however, it does not provide automatic failover between the master and slave Redis servers. Redis Sentinel is a service for managing Redis servers, capable of promoting a slave to master if the current master is not working as expected. Redis Sentinel is only available for Redis >= 2.8. Redis Sentinel can run on the same machines as Redis or on machines responsible for other services (preferred), such as RabbitMQ. Sentinel should be placed on machines that are believed to fail in an independent way. At least three instances of Redis Sentinel are required for a robust deployment. For more information about Redis Sentinel, please refer to the [official Sentinel documentation](http://redis.io/topics/sentinel). The following instructions will help you install and configure Redis Sentinel for Sensu's Redis connectivity.

_NOTE: [Redis master-slave replication](#redis-master-slave-replication) must be configured before configuring Sentinel._

### Install Redis

To configure Redis Sentinel on a machine, the Redis package must first be installed as it includes Sentinel. For Redis installation instructions, please refer to the [Sensu Redis installation guide](install-redis).

If the machine is not a regular Redis instance (master or slave) be sure to stop the Redis process and disable it on boot.

#### Ubuntu/Debian

~~~ shell
sudo /etc/init.d/redis-server stop
sudo update-rc.d redis-server disable
~~~

#### CentOS/RHEL

~~~ shell
sudo /etc/init.d/redis stop
sudo /sbin/chkconfig redis off
~~~

### Configure Redis Sentinel

By default, Sentinel reads a configuration file that can be found at `/etc/redis/sentinel.conf`. The Redis package may provide its own example `sentinel.conf` file, however, the Sensu docs provided file is required in order for the following instructions to work. Run the following command to download the provided Redis Sentinel configuration file.

~~~ shell
sudo wget -O /etc/redis/sentinel.conf http://sensuapp.org/docs/0.21/files/sentinel.conf
~~~

Sentinel not only reads its configuration from `/etc/redis/sentinel.conf`, but it also writes changes to it (state), so the Redis user must own the configuration file.

~~~ shell
sudo chown redis:redis /etc/redis/sentinel.conf
~~~

The Redis Sentinel configuration file requires a few changes before Sentinel can be started. The Sentinel configuration file at `/etc/redis/sentinel.conf` can be edited by your preferred text editor with sudo privileges, e.g. `sudo nano /etc/redis/sentinel.conf`.

Sentinel needs to be pointed at the current Redis master server. Change `your_redis_master_ip` to the address that the Redis master server is listening on. Leaving the master name as `mymaster` is recommended, as many other configuration options reference it.

~~~
sentinel monitor mymaster your_redis_master_ip 6379 2
~~~

Sentinel needs to know the Redis password, change `your_redis_password` to be the same value as `masterauth` (and `requirepass`) on the Redis master server.

~~~
sentinel auth-pass mymaster your_redis_password
~~~

The Redis package does not provide an init script for Sentinel. Run the following command to download a working Redis Sentinel init script.

~~~ shell
sudo wget -O /etc/init.d/redis-sentinel http://sensuapp.org/docs/0.21/files/redis-sentinel
~~~

The Redis Sentinel init script file needs to be executable.

~~~ shell
sudo chmod +x /etc/init.d/redis-sentinel
~~~

Enable the Redis Sentinel service on boot and start it:

#### Ubuntu/Debian

~~~ shell
sudo update-rc.d redis-sentinel defaults
sudo /etc/init.d/redis-sentinel start
~~~

#### CentOS/RHEL

~~~ shell
sudo /sbin/chkconfig redis-sentinel on
sudo /etc/init.d/redis-sentinel start
~~~

_NOTE: At least three instances of Redis Sentinel are required for a robust deployment._

### Verify Redis Sentinel operation

To verify that Redis Sentinel has been configured correctly and that it is operating, the Redis CLI tool (`redis-cli`) can be used to issue Redis commands to Sentinel to query for information. The `redis-cli` command line argument `-p` must be used to specify the Sentinel port (`26379`).

The following commands can be executed on any configured instance of Redis Sentinel. The Redis command `INFO` provides the Sentinel information.

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

## HAProxy for Redis

Sensu is currently unable to automatically switch between instances of Redis as the master changes. Because of this limitation, Sensu services that communicate with Redis (`sensu-server`, `sensu-api`, and `sensu-enterprise`) require a local instance of HAProxy to send their Redis commands to the correct instance of Redis (master). The following instructions will help you install and configure HAProxy for Sensu's Redis connectivity.

### Install HAProxy

HAProxy >= 1.5 is required in order for it to effectively route Redis traffic. Most Linux distributions require additional software repositories for HAProxy 1.5. The following commands add the appropriate repository for the distribution and install HAProxy.

#### Debian

~~~ shell
echo "deb http://cdn.debian.net/debian wheezy-backports main" | sudo tee -a /etc/apt/sources.list.d/backports.list
sudo apt-get update
sudo apt-get -y install haproxy -t wheezy-backports
~~~

#### Ubuntu

~~~ shell
sudo add-apt-repository ppa:vbernat/haproxy-1.5
sudo apt-get update
sudo apt-get -y install haproxy
~~~

#### CentOS/RHEL

To install HAProxy 1.5 on CentOS/RHEL, it must be compiled/installed from source.

The 1.5 source can be found at: [http://www.haproxy.org/download/1.5/src/](http://www.haproxy.org/download/1.5/src/)

### Configure HAProxy

By default, HAProxy reads a configuration file that can be found at `/etc/haproxy/haproxy.cfg`. The HAProxy package may provide its own example `haproxy.cfg` file, however, the Sensu docs provided file is required in order for the following instructions to work. Run the following command to download the provided HAProxy configuration file.

~~~ shell
sudo wget -O /etc/haproxy/haproxy.cfg http://sensuapp.org/docs/0.21/files/haproxy.cfg
~~~

The HAProxy configuration file requires a few changes before HAProxy can proxy traffic for Redis. The HAProxy configuration file at `/etc/haproxy/haproxy.cfg` can be edited by your preferred text editor with sudo privileges, e.g. `sudo nano /etc/haproxy/haproxy.cfg`.

HAProxy needs the Redis password in order to determine the health of the Redis backends and which one is the current master. Change `your_redis_password` to be the same value as `masterauth` (and `requirepass`) on the Redis servers.

~~~
tcp-check send AUTH\ your_redis_password\r\n
~~~

HAProxy needs to be pointed at the Redis servers (the backend). Change `your_redis_master_ip` to the address that the Redis master server is listening on. Change `your_redis_slave_ip` to the address that the Redis slave server is listening on. If you have configured additional Redis machines, add additional `server` lines here to add them to the backend.

~~~
server redis1 your_redis_master_ip:6379 check inter 5s
server redis2 your_redis_slave_ip:6379 check inter 5s
~~~

Restart HAProxy to load the new configuration.

~~~ shell
sudo /etc/init.d/haproxy restart
~~~

### Verify HAProxy for Redis operation

To verify that HAProxy has been configured correctly and is able to proxy Redis commands to the current Redis master, the Redis CLI tool (`redis-cli`) can be used to issue the `AUTH` and `INFO` commands to HAProxy. The `redis-cli` command line argument `-h` must be used to specify the HAProxy address and `-p` must be used to specify the port (`6380`).

The following commands can be executed on any machine with the `redis-cli` tool installed and network access to HAProxy. The Redis command `INFO` should provide the Redis master replication information (not the slave).

~~~ shell
redis-cli -h your_haproxy_ip -p 6380
AUTH your_redis_password
INFO
~~~

Example Redis master `INFO` via HAProxy:

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

The provided HAProxy configuration file at (`/etc/haproxy/haproxy.cfg`) includes a stats web interface, available on port `4242`, that uses basic authentication (admin:admin). The stats web interface can be used to observe the health of the Redis servers, only a single Redis server should be labeled as `UP` (the Redis master).

### Configuring Sensu for HA Redis

Once Redis master-slave replication, Redis Sentinel, and the local HAProxy instances have been configured, it's time to configure Sensu. To configure the Sensu services that communicate with Redis (`sensu-server`, `sensu-api`, and `sensu-enterprise`) to use the HA Redis configuration, they must be configured to use their local HAProxy instance for Redis connectivity. The following is an example Sensu redis configuration snippet, located at `/etc/sensu/conf.d/redis.json`. The following configuration could also be in `/etc/sensu/config.json`.

~~~ json
{
  "redis": {
    "host": "127.0.0.1",
    "port": 6380,
    "password": "your_redis_password"
  }
}
~~~
