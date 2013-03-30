---
layout: default
title: Installing Sensu
description: Sensu installation
version: 0.9
---

Installing Sensu
----------------
This article covers a manual installation of Sensu and its dependencies with the goal of outlining the process for you so that you may integrate it into your own tools and workflows. Sensu is typically deployed with a configuration management system such as Puppet or Chef and usable examples for each are available:

* [Chef](https://github.com/sensu/sensu-chef)
* [Puppet](https://github.com/sensu/sensu-puppet)

Introduction
------------
We will use 2 nodes, one will be our server and the other will be a simple client, with the following components on each. In order to simplify testing you can use one node for both roles since the server also has sensu-client running.

Sensu server node:

- rabbitmq
- redis
- sensu-server / sensu-client / sensu-api / sensu-dashboard

Sensu client node:

- sensu-client

Install Sensu Server dependencies
===========================

Install and configure RabbitMQ
-----------------------------

- [Install RabbitMQ on CentOS/RHEL](https://github.com/sensu/sensu/wiki/Install-RabbitMQ-on-CentOS-RHEL)
- [Install RabbitMQ on Ubuntu/Debian](https://github.com/sensu/sensu/wiki/Install-RabbitMQ-on-Ubuntu-Debian)

Install redis
-------------

Sensu requires Redis 2.0+

- [Install Redis on CentOS/RHEL](https://github.com/sensu/sensu/wiki/Install-Redis-on-CentOS-RHEL)
- [Install Redis on Ubuntu/Debian](https://github.com/sensu/sensu/wiki/Install-Redis-on-Ubuntu-Debian)

Install Sensu
=============

Install Sensu "Omnibus" Package
-------------------------

While Sensu can be install straight from ruby gem, the recommended installation method as of May 2012 is through the Sensu "omnibus" packages. These packages have no external dependencies and install their own isolated Ruby and Gems. This significantly simplifies installation and troubleshooting and also prevents any interference with other Ruby scripts or apps that may be running on your nodes. This is especially helpful in the case of sensu-client which may be installed on every node in your environment.

Sensu Package Repos
-------------------

Register the relevant Yum or Apt repo for your particular distribution. See the [Packages](Packages) guide for additional info.

Install Sensu "Omnibus" Package
-------------------

* Debian/Ubuntu:
```bash
apt-get update
apt-get install sensu
```

* RHEL/CentOS/Fedora
```bash
yum install sensu
```

Enable Sensu services
-------------------

The Sensu omnibus package ships with sysvinit (init.d) scripts installed directly to `/etc/init.d/`. All services are disabled by default. It is up to the user to enable the desired services.

Alternative supervisor scripts (such as upstart) are available in `/usr/share/sensu` for those that may want them.

On your Sensu server you will probably want all 4 services running. The rest of the nodes in your infrastructure only need `sensu-client`.

* CentOS/RHEL
```bash
chkconfig sensu-server on
chkconfig sensu-api on
chkconfig sensu-client on
chkconfig sensu-dashboard on
```

* Debian/Ubuntu:
```bash
update-rc.d sensu-server defaults
update-rc.d sensu-api defaults
update-rc.d sensu-client defaults
update-rc.d sensu-dashboard defaults
```

Configure Sensu
---------------

Copy the SSL client key + cert that we created earlier during the RabbitMQ installation into `/etc/sensu/ssl`

    cp client_key.pem client_cert.pem  /etc/sensu/ssl/

Next we need to configure sensu by editing `/etc/sensu/config.json`. For now we will create just enough config to start sensu. Later we will add checks and handlers.

Note (for later use) that Sensu will also read json config snippets out of the  `/etc/sensu/conf.d` directory so you can piece together a config easily using your CM tool.

```json
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
```

* Configure `/etc/sensu/conf.d/client.json`

```json
    {
      "client": {
        "name": "sensu-server.dom.tld",
        "address": "10.0.0.1",
        "subscriptions": [ "test" ]
      }
    }
```


Now let's try to start the Sensu components:

    sudo /etc/init.d/sensu-server start
    sudo /etc/init.d/sensu-api start
    sudo /etc/init.d/sensu-client start    
    sudo /etc/init.d/sensu-dashboard start    

If all goes well, the 4 processes mentioned above will be running and the dashboard will be accessible on `http://<SENSU SERVER>:8080`. Log files are available in `/var/log/sensu` in case anything is wrong.

Installing a Sensu client node
==============================

Installing and configuring a Sensu client is the same procedure as installing a Sensu server with the difference being that only the `sensu-client` service needs to be enabled and started.

The client will log to `/var/log/sensu/sensu-client.log`.


Next Steps
==========

Now that Sensu servers and clients are installed, the next steps are to create checks and handlers. Checks run on clients and report on status or metrics (http_alive? mysql_metrics, etc) and handlers run on the server and act on the output from checks (email alert, notify Pagerduty, add metrics to Graphite, etc)

- [HOWTO: Add a check](https://github.com/sensu/sensu/wiki/HOWTO:-Add-a-check)
- [HOWTO: Add a handler](https://github.com/sensu/sensu/wiki/HOWTO:-Add-a-handler)


If you have further questions please visit #sensu on IRC Freenode.
