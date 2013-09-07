---
layout: default
title: Installing Sensu
description: Sensu installation
version: '0.10'
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
See the [Packages](/{{ page.version }}/packages.html) guide for additional info.

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

Please see this page for additional notes and discussions on SSL certificates in Sensu: [ssl](/{{ page.version }}/ssl.html).

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

### Installing a Windows Sensu client node

Installing and configuring a Sensu client on Windows is very different from the steps above.

#### Install Sensu Client Package


To install the sensu-client package, follow the MSI install instructions on the [Packages](/{{ page.version }}/packages.html) page.

#### Create the Sensu Windows Service


Use the Windows SC command to create the service.

{% highlight bash %}
    sc \\HOSTNAME_OR_IP create sensu-client start= delayed-auto binPath= c:\opt\sensu\bin\sensu-client.exe DisplayName= "Sensu Client"
{% endhighlight %}

The space between the equals(=) and the value is required.

#### Create Directories for conf.d and ssl


It is recommended you use the default install directory C:\opt\sensu.  You can locate them elsewhere if you choose, just remember to modify your config files appropriately.

Create these directories with the Command Prompt or Windows Explorer.

{% highlight bash %}
    C:\opt\sensu\conf.d
    C:\opt\sensu\ssl
{% endhighlight %}

#### Copy cert.pem and key.pem to C:\opt\sensu\ssl


These can be obtained from the Sensu server or from another Sensu client node (located in /etc/sensu/ssl/ by default).

#### Create the client config file at C:\opt\sensu\conf.d\config.json


{% highlight json %}
    {
      "rabbitmq": {
        "host": "SENSU_HOSTNAME",
        "port": 5671,
        "vhost": "/sensu",
        "user": "SENSU_USERNAME",
        "password": "SENSU_PASSWORD",
        "ssl": {
          "cert_chain_file": "/opt/sensu/ssl/cert.pem",
          "private_key_file": "/opt/sensu/ssl/key.pem"
        }
      }
    }    
{% endhighlight %}

Be sure to change the port and vhost values if you are not using the defaults.

#### Create C:\opt\sensu\conf.d\client.json


{% highlight json %}
    {
      "client": {
        "name": "CLIENT_NODE_NAME",
        "address": "CLIENT_IP_ADDRESS",
        "subscriptions": [
          "SUBSCRIPTION_NAME"  
        ]
      }
    }
{% endhighlight %}

#### Edit C:\opt\sensu\bin\sensu-client.xml


We need to add the -c and -d parameters to point to our newly created config files.

{% highlight xml %}
  <!--
    Windows service definition for Sensu
  -->
  <service>
    <id>sensu-client</id>
    <name>Sensu Client</name>
    <description>This service runs a Sensu client</description>
    <executable>C:\opt\sensu\embedded\bin\ruby</executable>
    <arguments>C:\opt\sensu\embedded\bin\sensu-client -c C:\opt\sensu\config.json -d C:\opt\sensu\conf.d -l C:\opt\sensu\sensu-client.log</arguments>
  </service>
{% endhighlight %}


#### Start the sensu-client service


Start the Sensu Client service from the Services.msc panel or from the Command Prompt.  Review the C:\opt\sensu\sensu-client.log for errors.

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

