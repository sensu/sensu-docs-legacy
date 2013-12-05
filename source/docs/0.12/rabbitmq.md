---
version: "0.12"
category: "Installation"
title: "RabbitMQ"
warning: "<strong>IMPORTANT NOTE:</strong> Due to the state of flux in
Erlang and the Erlang-SSL module, we have been unable to get RabbitMQ
and SSL working on Ubuntu platforms < 11.10 and Debian 6.x."
---

# RabbitMQ

All of the Sensu components require access to an instance of RabbitMQ,
in order to communicate with each-other.

## Install RabbitMQ on Debian and Ubuntu

### Step #1 - Install erlang

``` shell
apt-get -y install erlang-nox
```

### Step #2 - Install RabbitMQ

Based on the official RabbitMQ install guide:
[http://www.rabbitmq.com/install-debian.html](http://www.rabbitmq.com/install-debian.html)

``` shell
wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc
echo "deb     http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
apt-get update
apt-get install rabbitmq-server
```

## Install RabbitMQ on CentOS (RHEL)

### Step #1 - Install erlang

#### CentOS 5

**IMPORTANT NOTE** - Install both the EPEL-5 and epel-erlang yum
  repositories. The EPEL-5 yum repository contains the older R12B
  version of Erlang which would work fine with RabbitMQ, except we
  wouldn't have access to SSL nor the web management plugins. Thus,
  we'll be installing a newer Erlang from the `epel-erlang` repository
  which provides R14B for CentOS 5.

``` shell
rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm
wget -O /etc/yum.repos.d/epel-erlang.repo http://repos.fedorapeople.org/repos/peter/erlang/epel-erlang.repo
```

#### CentOS 6

Install the EPEL-6 yum repository which contains Erlang R14B.

``` shell
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
```

Install erlang.

``` shell
yum install erlang
```

### Step #2 - Install RabbitMQ

Based on the official RabbitMQ install guide:
[http://www.rabbitmq.com/install-rpm.html](http://www.rabbitmq.com/install-rpm.html)

``` shell
rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.2.1/rabbitmq-server-3.2.1-1.noarch.rpm
```

Set RabbitMQ to start on boot and start it up:

``` shell
update-rc.d rabbitmq-server defaults
/etc/init.d/rabbitmq-server start
```

## Configure SSL

**IMPORTANT NOTE** - Due to the state of flux in Erlang and the
  Erlang-SSL module, we have been unable to get RabbitMQ and SSL
  working on Ubuntu platforms < 11.10 and Debian 6.x.

You must have already generated an SSL certificate authority and
certificates. If not, please follow the instructions on [SSL
certificates](certificates) before proceeding.

### Step #1 - Install RabbitMQ certificate authority and certificates

Create an SSL directory on the RabbitMQ server.

``` shell
mkdir -p /etc/rabbitmq/ssl
```

Copy the following generated SSL files to the newly created SSL
directory on the RabbitMQ server. These files were created by
following the self-signed [SSL certificates](certificates)
instructions.

* `sensu_ca/cacert.pem`
* `server/cert.pem`
* `server/key.pem`

You will end up with a directory listing like:

```
$ ls /etc/rabbitmq/ssl
cacert.pem cert.pem   key.pem
```

### Step #2 - Configure the RabbitMQ SSL listener

Edit (or create) `/etc/rabbitmq/rabbitmq.config`, configuring RabbitMQ
to listen for SSL connections on port `5671`, and to use the generated
certificate authority and server certificate.

``` erlang
[
    {rabbit, [
    {ssl_listeners, [5671]},
    {ssl_options, [{cacertfile,"/etc/rabbitmq/ssl/cacert.pem"},
                   {certfile,"/etc/rabbitmq/ssl/cert.pem"},
                   {keyfile,"/etc/rabbitmq/ssl/key.pem"},
                   {verify,verify_peer},
                   {fail_if_no_peer_cert,true}]}
  ]}
].
```

Restart RabbitMQ.

``` shell
/etc/init.d/rabbitmq-server restart
```

## Create credentials

### Step #1 - Create a RabbitMQ vhost for Sensu

``` shell
rabbitmqctl add_vhost /sensu
```

### Step #2 - Create a RabbitMQ user with permissions for the Sensu vhost

Be sure to change `mypass` to something secretive.

``` shell
rabbitmqctl add_user sensu mypass
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
```

## Optional

### Enable the RabbitMQ web management console

``` shell
rabbitmq-plugins enable rabbitmq_management
```
