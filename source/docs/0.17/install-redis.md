---
version: 0.17
category: "Installation Guide"
title: "Install Redis"
next:
  url: "install-repositories"
  text: "Install Repositories"
---

# Overview

Redis is a key-value database, which [describes itself](http://redis.io/topics/introduction) as _"an open source, BSD licensed, advanced key-value cache and store"_. Sensu uses Redis for storing persistent data. Two Sensu services, the server and API, require access to the same instance of Redis to function.

The following instructions will help you to:

- Install Redis

# Install Redis

## Ubuntu/Debian {#install-redis-on-ubuntu}

Install Redis (>= 1.3.14) from the distribution repository:

~~~ shell
sudo apt-get update
sudo apt-get install redis-server
~~~

## CentOS/RHEL {#install-redis-on-centos}

Install Redis (>= 1.3.14) from the EPEL repository:

_NOTE: installation of Redis from EPEL repositories depends on having already installed the EPEL repositories for your CentOS/RHEL release, as described during [RabbitMQ installation](install-rabbitmq#install-rabbitmq-on-centos-step-1)._

~~~ shell
sudo yum install redis
~~~

# Running Redis

Enable the RabbitMQ service on boot and start it:

## Ubuntu/Debian {#running-redis-on-ubuntu}

~~~ shell
sudo /etc/init.d/redis-server start
~~~

## CentOS/RHEL {#running-redis-on-centos}

~~~ shell
sudo /sbin/chkconfig redis on
sudo /etc/init.d/redis start
~~~
