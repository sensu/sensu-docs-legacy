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
