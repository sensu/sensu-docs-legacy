---
version: 0.19
category: "Installation Guide"
title: "Install Redis"
next:
  url: "install-repositories"
  text: "Install Repositories"
success: "<strong>NOTE:</strong> this is part 2 of 6 steps in the Sensu
  Installation Guide. For the best results, please make sure to follow the
  instructions carefully and complete all of the steps in each section before
  moving on."
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

Install the [EPEL](https://fedoraproject.org/wiki/EPEL) repository [for your CentOS/RHEL release](http://fedoraproject.org/wiki/EPEL/FAQ#howtouse):

The following command will install the EPEL repository for CentOS/RHEL 6; for other CentOS/RHEL releases, please refer to [http://fedoraproject.org/wiki/EPEL/FAQ#howtouse](http://fedoraproject.org/wiki/EPEL/FAQ#howtouse).

~~~ shell
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
~~~

Install Redis (>= 1.3.14) from the EPEL repository:

~~~ shell
sudo yum install redis
~~~

# Running Redis

Enable the Redis service on boot and start it:

## Ubuntu/Debian {#running-redis-on-ubuntu}

~~~ shell
sudo update-rc.d redis-server defaults
sudo /etc/init.d/redis-server start
~~~

## CentOS/RHEL {#running-redis-on-centos}

~~~ shell
sudo /sbin/chkconfig redis on
sudo /etc/init.d/redis start
~~~

You should now have Redis running, which can be confirmed by running the command: <kbd>redis-cli ping</kbd>. If you get a `PONG` response, you should be ready to move on to the next step in the guide.
