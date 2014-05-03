---
version: "0.12"
category: "Installation"
title: "Upgrading"
---

# Upgrading

If you are upgrading Sensu from version 0.11.x or newer, just upgrade
the Sensu package and restart the services, no additional steps are
required.

If you are upgrading Sensu from version 0.10.x or earlier, you will
need to stop the Sensu server and API services, and then delete the
result and keepalive queues from RabbitMQ before the upgrade. You will
need to have `rabbitmqadmin` installed to do this.

### Step #1 - Stop the Sensu servers

~~~ shell
sudo /etc/init.d/sensu-server stop
~~~

### Step #2 - Stop the Sensu APIs

~~~ shell
sudo /etc/init.d/sensu-api stop
~~~

### Step #3 - Delete the RabbitMQ queues

Run this on the RabbitMQ system.

You may need to specify the Sensu RabbitMQ vhost (`--vhost=`), user
(`--username=`), and password (`--password=`).

For help, run `rabbitmqadmin --help`.

~~~ shell
rabbitmqadmin delete queue name='results'
rabbitmqadmin delete queue name='keepalives'
~~~

### Step #4 - Upgrade the package

Upgrade the Sensu package and restart the Sensu services.
