---
layout: default
title: Installing Sensu
description: Sensu installation
version: 0.9
---

# Installing Sensu

This page demonstrates a manual installation of Sensu and its
dependencies with the goal of outlining the process for you so that you
may integrate it into your own tools and workflows. Sensu is typically
(and best!) deployed with a configuration management system such as
Puppet or Chef and usable examples for each are available:

* [Chef](https://github.com/sensu/sensu-chef)
* [Puppet](https://github.com/sensu/sensu-puppet)

## Introduction

We will use 2 nodes, one will be our server and the other will be a
simple client, with the following components on each. In order to
simplify testing you can use one node for both roles since the server
also has the Sensu client running.

Sensu server node:

- RabbitMQ
- Redis
- Sensu server
- Sensu client
- Sensu API
- Sensu Dashboard

Sensu client node:

- Sensu client

### Install Sensu Server dependencies

#### Install and configure RabbitMQ

- [Installing RabbitMQ on CentOS or RHEL](/{{ page.version }}/installing_rabbitmq_centos.html)
- [Installing RabbitMQ on Debian or Ubuntu](/{{ page.version }}/installing_rabbitmq_debian.html)

#### Install redis

Sensu requires Redis 2.0+

##### Installing Redis on CentOS or RHEL

1. Install the EPEL repos if you haven't already.

Both the EPEL-5 and EPEL-6 repos contain a version of Redis that is new
enough for Sensu - 2.0 in EPEL-5 and 2.2 in EPEL-6, so no special magic
is needed here.

{% highlight bash %}
yum install redis
/sbin/chkconfig redis on
/etc/init.d/redis start
{% endhighlight %}

##### Installing Redis on Debian or Ubuntu

###### Ubuntu <= 10.04

You will need to download and install Redis 2.0+ from source on these distribution.

###### Debian 6.x

1. Add Backports to sources

    echo "deb     http://backports.debian.org/debian-backports squeeze-backports main contrib non-free" >> /etc/apt/sources.list

2. Update sources

    apt-get update

3. Install Redis

    apt-get -t squeeze-backports install redis-server

###### Ubuntu > 10.04

The default distro repo ships with a new enough Redis.

{% highlight bash %}
apt-get install redis-server
/etc/init.d/redis-server start
{% endhighlight %}

### Install Sensu

#### Install Sensu "Omnibus" Package

While Sensu can be install straight from ruby gem, the recommended
installation method as of May 2012 is through the Sensu "omnibus"
packages. These packages have no external dependencies and install their
own isolated Ruby and Gems. This significantly simplifies installation
and troubleshooting and also prevents any interference with other Ruby
scripts or apps that may be running on your nodes. This is especially
helpful in the case of sensu-client which may be installed on every node
in your environment.

#### Sensu Package Repos

Register the relevant Yum or Apt repo for your particular distribution.
See the [Packages](/{{ page.version }}/sensu_packages.html) guide for additional info.

#### Install Sensu "Omnibus" Package

* Debian/Ubuntu:

{% highlight bash %}
apt-get update
apt-get install sensu
{% endhighlight %}

* RHEL/CentOS/Fedora
{% highlight bash %}
yum install sensu
{% endhighlight %}

#### Enable Sensu services

The Sensu omnibus package ships with sysvinit (init.d) scripts installed
directly to `/etc/init.d/`. All services are disabled by default. It is
up to the user to enable the desired services.

Alternative supervisor scripts (such as upstart) are available in `/usr/share/sensu` for those that may want them.

On your Sensu server you will probably want all 4 services running. The rest of the nodes in your infrastructure only need `sensu-client`.

* CentOS/RHEL
{% highlight bash %}
chkconfig sensu-server on
chkconfig sensu-api on
chkconfig sensu-client on
chkconfig sensu-dashboard on
{% endhighlight %}

* Debian/Ubuntu:
{% highlight bash %}
update-rc.d sensu-server defaults
update-rc.d sensu-api defaults
update-rc.d sensu-client defaults
update-rc.d sensu-dashboard defaults
{% endhighlight %}

#### Configure Sensu

Copy the SSL client key + cert that we created earlier during the RabbitMQ installation into `/etc/sensu/ssl`

{% highlight bash %}
    cp client_key.pem client_cert.pem  /etc/sensu/ssl/
{% endhighlight %}

Next we need to configure sensu by editing `/etc/sensu/config.json`. For
now we will create just enough config to start sensu. Later we will add
checks and handlers.

Note (for later use) that Sensu will also read json config snippets out
of the `/etc/sensu/conf.d` directory so you can piece together a config
easily using your CM tool.

{% highlight json %}
    {
      "rabbitmq": {
        "ssl": {
          "private_key_file": "/etc/sensu/ssl/client_key.pem",
          "cert_chain_file": "/etc/sensu/ssl/client_cert.pem"
        },
        "port": 5671,
        "host": "localhost",
        "user": "sensu",
        "password": "mypass",
        "vhost": "/sensu"
      },
      "redis": {
        "host": "localhost",
        "port": 6379
      },
      "api": {
        "host": "localhost",
        "port": 4567
      },
      "dashboard": {
        "host": "localhost",
        "port": 8080,
        "user": "admin",
        "password": "secret"
      },
      "handlers": {
        "default": {
          "type": "pipe",
          "command": "true"
        }
      }
    }
{% endhighlight %}

* Configure `/etc/sensu/conf.d/client.json`

{% highlight json %}
    {
      "client": {
        "name": "sensu-server.dom.tld",
        "address": "10.0.0.1",
        "subscriptions": [ "test" ]
      }
    }
{% endhighlight %}


Now let's try to start the Sensu components:

{% highlight bash %}
    sudo /etc/init.d/sensu-server start
    sudo /etc/init.d/sensu-api start
    sudo /etc/init.d/sensu-client start    
    sudo /etc/init.d/sensu-dashboard start    
{% endhighlight %}

If all goes well, the 4 processes mentioned above will be running and
the dashboard will be accessible on `http://<SENSU SERVER>:8080`. Log
files are available in `/var/log/sensu` in case anything is wrong.

### Installing a Sensu client node

Installing and configuring a Sensu client is the same procedure as
installing a Sensu server with the difference being that only the
`sensu-client` service needs to be enabled and started.

The client will log to `/var/log/sensu/sensu-client.log`.

## Next Steps

Now that Sensu servers and clients are installed, the next steps are to
create checks and handlers. Checks run on clients and report on status
or metrics (http_alive, mysql_metrics, etc) and handlers run on the
server and act on the output from checks (email alert, notify Pagerduty,
add metrics to Graphite, etc)

- [Adding a check](/{{ page.version }}/adding_a_check.html)
- [Adding a handler](/{{ page.version }}/adding_a_handler.html)

If you have further questions please visit the `#sensu` IRC channel on
Freenode or send an email to the `sensu-users` mailing list.

