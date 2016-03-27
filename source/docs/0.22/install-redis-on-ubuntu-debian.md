---
version: 0.22
category: "Installation Guide"
title: "Install Redis on Ubuntu/Debian"
next:
  url: "install-rabbitmq"
  text: "Install RabbitMQ"
---

# Install Redis on Ubuntu/Debian

- [Install Redis using APT](#install-redis-using-apt)
- [Managing the Redis service/process](#manage-the-redis-service-process)
- [Verify that Redis is working](#verify-that-redis-is-working)
- [Configure Sensu](#configure-sensu)
  - [Example Standalone Configuration](#example-standalone-configuration)
  - [Example Distributed Configuration](#example-distributed-configuration)
  - [Using Redis as the Sensu Transport](#using-redis-as-the-sensu-transport)

## Install Redis using APT

Install Redis (>= 1.3.14) from the distribution repository:

~~~ shell
sudo apt-get update
sudo apt-get -y install redis-server
~~~

## Managing the Redis service/process

To enable the Redis service on boot and start it, you'll need to install its
init scripts using the `update-rc.d` utility.

~~~ shell
sudo update-rc.d redis-server defaults
sudo /etc/init.d/redis-server start
~~~

## Verify that Redis is working

Once you have installed and started the Redis service, you should be able to
confirm that Redis is ready to use by running the command:  <kbd>redis-cli
ping</kbd>. If you get a `PONG` response, you are ready to move on to the next
step in the guide.

## Configure Sensu

The following Sensu configuration files are provided as examples. Please review
the [Redis reference documentation][1] for additional information on configuring
Sensu to communicate with Redis, and the [reference documentation on Sensu
configuration][2] for more information on how Sensu loads configuration.

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
   unless Redis is being used as the [Sensu Transport][3]. If you're not
   planning on using Redis as the Sensu Transport, you do not need to create a
   Redis configuration file on systems where the Sensu client is installed._

### Using Redis as the Sensu Transport

1. If you are [planning to use Redis][4] as your [Sensu Transport][3], please
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

[1]:  redis
[2]:  configuration
[3]:  transport
[4]:  installation-prerequisites#selecting-a-transport
