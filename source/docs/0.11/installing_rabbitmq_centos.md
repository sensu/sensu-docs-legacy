---
version: "0.11"
category: "Installation"
title: "Install RabbitMQ on CentOS and RHEL"
---

# Install RabbitMQ on CentOS RHEL

## Erlang

### Erlang Yum Repos

(CentOS 5 only) Install both the EPEL-5 and epel-erlang yum repos. The EPEL-5 yum repo contains the older R12B version of Erlang which would work fine with rabbit except we wouldn't have access to SSL nor the web management plugins. Thus, we'll be installing a newer Erlang from the `epel-erlang` repo which provides R14B for cent5.

``` bash
rpm -Uvh http://download.fedoraproject.org/pub/epel/5/i386/repoview/epel-release.html
wget -O /etc/yum.repos.d/epel-erlang.repo http://repos.fedorapeople.org/repos/peter/erlang/epel-erlang.repo
```
 
(CentOS 6 only) Install the EPEL-6 yum repo which contains Erlang R14B:

``` bash
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
```

### Install Erlang

``` bash
yum install erlang
```

## RabbitMQ

Based on the rabbit install guide from here: [http://www.rabbitmq.com/install-rpm.html](http://www.rabbitmq.com/install-rpm.html)

### Install RabbitMQ from RPM

``` bash
rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.1.4/rabbitmq-server-3.1.4-1.noarch.rpm
```

### Configure RabbitMQ SSL

We need to make some SSL certs for our rabbitmq server and the sensu clients. I put a simple script up on [github](https://github.com/joemiller/joemiller.me-intro-to-sensu) to help with this. You'll want to change a few things in the `openssl.cnf` to for your organization if you use this in production. The script will generate a few files that we'll need throughout the guide, so keep them nearby.

``` bash
git clone git://github.com/joemiller/joemiller.me-intro-to-sensu.git
cd joemiller.me-intro-to-sensu/
./ssl_certs.sh clean
./ssl_certs.sh generate
```

Configure RabbitMQ to use these SSL certs

``` bash
mkdir /etc/rabbitmq/ssl
cp server_key.pem /etc/rabbitmq/ssl/
cp server_cert.pem /etc/rabbitmq/ssl/
cp testca/cacert.pem /etc/rabbitmq/ssl/
```
    
Create `/etc/rabbitmq/rabbitmq.config`:

``` erlang
[
    {rabbit, [
    {ssl_listeners, [5671]},
    {ssl_options, [{cacertfile,"/etc/rabbitmq/ssl/cacert.pem"},
                   {certfile,"/etc/rabbitmq/ssl/server_cert.pem"},
                   {keyfile,"/etc/rabbitmq/ssl/server_key.pem"},
                   {verify,verify_peer},
                   {fail_if_no_peer_cert,true}]}
  ]}
].
```

### Install RabbitMQ management console

Optional, but potentially very useful.

``` bash
rabbitmq-plugins enable rabbitmq_management
```

### Start and verify RabbitMQ

Set RabbitMQ to start on boot and start it up immediately:

``` bash
/sbin/chkconfig rabbitmq-server on
/etc/init.d/rabbitmq-server start
```

Verify operation with the RabbitMQ Web UI: Username is "guest", password is "guest" - `http://<RABBITMQ-SERVER>:55672`. Protocol amqp should be bound to port 5672 and amqp/ssl on port 5671.

### Create RabbitMQ vhost and user for Sensu

Finally, let's create a `/sensu` vhost and a `sensu` user/password on our rabbit:

``` bash
rabbitmqctl add_vhost /sensu
rabbitmqctl add_user sensu mypass
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
```

