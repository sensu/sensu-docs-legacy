---
version: 0.17
category: "Installation Guide"
title: "Install RabbitMQ"
next:
  url: "install-redis"
  text: "Install Redis"
info: "Due to the state of flux in Erlang and the Erlang-SSL module, we have been unable to get RabbitMQ and SSL working on Ubuntu platforms < 11.10 and Debian 6.x."
warning: "Erlang RB14B04 is vulnerable to the POODLE attack. Please upgrade to a more recent version; R16B01 or newer."
---

# Overview

RabbitMQ is a message bus, which [describes itself](http://www.rabbitmq.com/features.html) as _"a messaging broker - an intermediary for messaging. It gives your applications a common platform to send and receive messages, and your messages a safe place to live until received"_. Sensu services use RabbitMQ to communicate with one another. Every Sensu service requires access to the same instance of RabbitMQ to function.

The following instructions will help you to:

- Install Erlang
- Install RabbitMQ

# Install RabbitMQ

## Ubuntu/Debian {#install-rabbitmq-on-ubuntu}

### Step #1: Install Erlang {#install-rabbitmq-on-ubuntu-step-1}

Install Erlang from the distribution repository:

~~~ shell
sudo apt-get update
sudo apt-get -y install erlang-nox
~~~

### Step #2: Install RabbitMQ {#install-rabbitmq-on-ubuntu-step-2}

Install RabbitMQ from the official RabbitMQ repositories, as suggested in the official RabbitMQ [installation guide](http://www.rabbitmq.com/install-debian.html):

~~~ shell
sudo wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo apt-key add rabbitmq-signing-key-public.asc
echo "deb     http://www.rabbitmq.com/debian/ testing main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
sudo apt-get update
sudo apt-get install rabbitmq-server
~~~

## CentOS/RHEL {#install-rabbitmq-on-centos}

### Step #1: Install Erlang {#install-rabbitmq-on-centos-step-1}

Install the [EPEL](https://fedoraproject.org/wiki/EPEL) repository [for your CentOS/RHEL release](http://fedoraproject.org/wiki/EPEL/FAQ#howtouse):

The following command will install the EPEL repository for CentOS/RHEL 6; for other CentOS/RHEL releases, please refer to [http://fedoraproject.org/wiki/EPEL/FAQ#howtouse](http://fedoraproject.org/wiki/EPEL/FAQ#howtouse).

~~~ shell
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
~~~

Install Erlang from the EPEL repository:

~~~ shell
sudo yum install erlang
~~~

### Step #2: Install RabbitMQ {#install-rabbitmq-on-centos-step-2}

Install RabbitMQ using the official RabbitMQ RPM, as suggested in the official RabbitMQ [installation guide](http://www.rabbitmq.com/install-rpm.html):

~~~ shell
sudo rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.0/rabbitmq-server-3.5.0-1.noarch.rpm
~~~

# Running RabbitMQ

Enable the RabbitMQ service on boot and start it:

## Ubuntu/Debian {#running-rabbitmq-on-ubuntu}

~~~ shell
sudo update-rc.d rabbitmq-server defaults
sudo /etc/init.d/rabbitmq-server start
~~~

## CentOS/RHEL {#running-rabbitmq-on-centos}

~~~ shell
sudo chkconfig rabbitmq-server on
sudo /etc/init.d/rabbitmq-server start
~~~

# Configure RabbitMQ

Access to RabbitMQ is restricted by [access controls](https://www.rabbitmq.com/access-control.html) (e.g. username/password). For Sensu services to connect to RabbitMQ a RabbitMQ virtual host (vhost) and user credentials will need to be created. 

## Create vhost

~~~ shell
sudo rabbitmqctl add_vhost /sensu
~~~

## Create user

~~~ shell
sudo rabbitmqctl add_user sensu secret
sudo rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
~~~
