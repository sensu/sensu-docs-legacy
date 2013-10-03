---
layout: default
title: Install RabbitMQ on Debian and Ubuntu
description: Install RabbitMQ on Debian and Ubuntu
version: '0.11'
---

# Install RabbitMQ on Debian and Ubuntu

Erlang
------

### Install Erlang

{% highlight bash %}
apt-get -y install erlang-nox
{% endhighlight %}

RabbitMQ
--------
Based on the rabbit install guide :
[http://www.rabbitmq.com/install-debian.html](http://www.rabbitmq.com/install-debian.html)

### Install RabbitMQ from Deb

{% highlight bash %}
    echo "deb http://www.rabbitmq.com/debian/ testing main" >/etc/apt/sources.list.d/rabbitmq.list

    curl -L -o ~/rabbitmq-signing-key-public.asc http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
    apt-key add ~/rabbitmq-signing-key-public.asc

    apt-get update
    apt-get -y --allow-unauthenticated --force-yes install rabbitmq-server
{% endhighlight %}

### Configure RabbitMQ SSL

**IMPORTANT NOTE** - Due to the state of flux in Erlang and the
 Erlang-SSL module, we have been unable to get RabbitMQ and SSL working
on Ubuntu platforms < 11.10 and Debian 6.x.

We need to make some SSL certs for our rabbitmq server and the sensu
clients. I put a simple script up on
[github](https://github.com/joemiller/joemiller.me-intro-to-sensu) to
help with this. You'll want to change a few things in the `openssl.cnf`
to for your organization if you use this in production. The script will
generate a few files that we'll need throughout the guide, so keep them
nearby.

{% highlight bash %}
    git clone git://github.com/joemiller/joemiller.me-intro-to-sensu.git
    cd joemiller.me-intro-to-sensu/
    ./ssl_certs.sh clean
    ./ssl_certs.sh generate
{% endhighlight %}

Configure RabbitMQ to use these SSL certs

{% highlight bash %}
    mkdir /etc/rabbitmq/ssl
    cp server_key.pem /etc/rabbitmq/ssl/
    cp server_cert.pem /etc/rabbitmq/ssl/
    cp testca/cacert.pem /etc/rabbitmq/ssl/
{% endhighlight %}

Create `/etc/rabbitmq/rabbitmq.config`:

{% highlight erlang %}
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
{% endhighlight %}

### Install RabbitMQ management console

Optional, but potentially very useful.

{% highlight bash %}
rabbitmq-plugins enable rabbitmq_management
{% endhighlight %}

### Start and verify RabbitMQ
Set RabbitMQ to start on boot and start it up immediately:

{% highlight bash %}
update-rc.d rabbitmq-server defaults
/etc/init.d/rabbitmq-server start
{% endhighlight %}

Verify operation with the RabbitMQ Web UI: Username is "guest", password
is "guest" - `http://<SENSU-SERVER>:55672`. Protocol amqp should be
bound to port 5672 and amqp/ssl on port 5671.

### Create RabbitMQ vhost and user for Sensu
Finally, let's create a `/sensu` vhost and a `sensu` user/password on
our rabbit:

{% highlight bash %}
    rabbitmqctl add_vhost /sensu
    rabbitmqctl add_user sensu mypass
    rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
{% endhighlight %}

