---
version: 0.23
category: "Installation Guide"
title: "Install Redis on RHEL/CentOS"
next:
  url: "install-rabbitmq"
  text: "Install RabbitMQ"
---

# Install Redis on RHEL/CentOS

- [Install Redis from the EPEL repositories](#install-redis-from-the-epel-repositories)
- [Managing the Redis service/process](#manage-the-redis-service-process)
- [Verify that Redis is working](#verify-that-redis-is-working)
- [Configure Sensu](#configure-sensu)
  - [Example Standalone Configuration](#example-standalone-configuration)
  - [Example Distributed Configuration](#example-distributed-configuration)
  - [Using Redis as the Sensu Transport](#using-redis-as-the-sensu-transport)

## Install Redis from the EPEL repositories

Because Redis is not available by default in all RHEL and CentOS distribution
repositories, you will need to install the corresponding [EPEL][1] repository
[for your CentOS/RHEL release][2] (supported platforms are RHEL 5, RHEL 6, and
RHEL 7).

1. Install EPEL on RHEL/CentOS 6:

   ~~~ shell
   sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
   ~~~

   _NOTE: the preceding command will install the EPEL repository for
   RHEL/CentOS **version 6 ONLY**. For other RHEL/CentOS releases (i.e. version
   5 or 7), please refer to the [intructions for installing the correct EPEL for
   your release][2]._

2. Install Redis using YUM

   Install Redis (>= 1.3.14) from the EPEL repository:

   ~~~ shell
   sudo yum install redis
   ~~~

## Managing the Redis service/process

Install the Redis init scripts using the [`chkconfig` utility][3]:

~~~ shell
sudo /sbin/chkconfig redis on
sudo /etc/init.d/redis start
~~~

## Verify that Redis is working

Once you have installed and started the Redis service, you should be able to
confirm that Redis is ready to use by running the command:  <kbd>redis-cli
ping</kbd>. If you get a `PONG` response, you are ready to move on to the next
step in the guide.

## Configure Sensu

The following Sensu configuration files are provided as examples. Please review
the [Redis reference documentation][4] for additional information on configuring
Sensu to communicate with Redis, and the [reference documentation on Sensu
configuration][5] for more information on how Sensu loads configuration.

### Example Standalone Configuration

1. Copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/redis.json`:

   ~~~ json
   {
     "redis": {
       "host": "127.0.0.1",
       "port": 6379
     }
   }
   ~~~

   _WARNING: using `"localhost"` instead of `127.0.0.1` for the `host`
   configuration on systems that support IPv6 may result in an [IPv6 "localhost"
   resolution (i.e. `::1`)][8] rather than an IPv4 "localhost" resolution (i.e.
   `127.0.0.1`). This is not incorrect behavior because Sensu does support IPv6,
   however if Redis is not configured to listen on IPv6, this will result in a
   connection error and log entries indicating a **"redis connection error"**
   with an **"unable to connect to redis server"** error message._

### Example Distributed Configuration

1. Obtain the IP address of the system where Redis is installed. For the purpose
   of this guide, we will use `10.0.1.5` as our example IP address.

2. Create a configuration file  with the following contents at
   `/etc/sensu/conf.d/redis.json` on the Sensu server and API system(s), and all
   systems running the Sensu client:

   ~~~ json
   {
     "redis": {
       "host": "10.0.1.5",
       "port": 6379,
       "auto_reconnect": true
     }
   }
   ~~~

   _NOTE: the `sensu-client` process does not require Redis configuration
   unless Redis is being used as the [Sensu Transport][6]. If you're not
   planning on using Redis as the Sensu Transport, you do not need to create a
   Redis configuration file on systems where the Sensu client is installed._

### Using Redis as the Sensu Transport

1. If you are [planning to use Redis][7] as your [Sensu Transport][6], please
   copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/transport.json`:

   ~~~ json
   {
     "transport": {
       "name": "redis",
       "reconnect_on_error": true
     }
   }
   ~~~

   This will inform the Sensu services to use the defined Redis configuration as
   the Sensu Transport (instead of looking for the default transport, RabbitMQ).

[1]:  https://fedoraproject.org/wiki/EPEL
[2]:  http://fedoraproject.org/wiki/EPEL/FAQ#howtouse
[3]:  https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-services-chkconfig.html
[4]:  redis
[5]:  configuration
[6]:  transport
[7]:  installation-prerequisites#selecting-a-transport
[8]:  https://en.wikipedia.org/wiki/IPv6_address#Local_addresses
