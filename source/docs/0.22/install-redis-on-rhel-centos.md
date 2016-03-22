---
version: 0.22
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
repositories, you will need to install the corresponding [EPEL][epel] repository
[for your CentOS/RHEL release][epel-howto] (supported platforms are RHEL 5, RHEL
6, and RHEL 7).

1. Install EPEL on RHEL/CentOS 6:

   ~~~ shell
   sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
   ~~~

   _NOTE: the preceding command will install the EPEL repository for
   RHEL/CentOS **version 6 ONLY**. For other RHEL/CentOS releases (i.e. version
   5 or 7), please refer to the [intructions for installing the correct EPEL for
   your release][epel-howto]._

2. Install Redis using YUM

   Install Redis (>= 1.3.14) from the EPEL repository:

   ~~~ shell
   sudo yum install redis
   ~~~

## Managing the Redis service/process

Install the Redis init scripts using the [`chkconfig` utility][chkconfig]:

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
the [Redis reference documentation](redis) for additional information on
configuring Sensu to communicate with Redis, and the [reference documentation on
Sensu configuration](configuration) for more information on how Sensu loads
configuration.

### Example Standalone Configuration

1. Copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/redis.json`:

   ~~~ json
   {
     "redis": {
       "host": "localhost",
       "port": 6379
     }
   }
   ~~~

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
   unless Redis is being used as the [Sensu Transport](transport). If you're not
   planning on using Redis as the Sensu Transport, you do not need to create a
   Redis configuration file on systems where the Sensu client is installed._

### Using Redis as the Sensu Transport

1. If you are [planning to use Redis][prereqs] as your [Sensu
   Transport](transport), please copy the following contents to a configuration
   file located at `/etc/sensu/conf.d/transport.json`:

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

[epel]:         https://fedoraproject.org/wiki/EPEL
[epel-howto]:   http://fedoraproject.org/wiki/EPEL/FAQ#howtouse
[chkconfig]:    https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-services-chkconfig.html
[prereqs]:      installation-strategies#selecting-a-transport
