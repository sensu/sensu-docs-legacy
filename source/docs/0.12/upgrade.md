---
version: "0.12"
category: "Installation"
title: "Upgrade"
---

## Upgrading Sensu

If you are upgrading to the latest version of Sensu from version 0.10.x
or earlier you will need to stop both the Sensu server and API processes
and delete the result and keepalive queues from RabbitMQ before the
upgrade. You will need to have rabbitmqadmin installed to do this.

``` shell
sudo /etc/init.d/sensu-server stop
sudo /etc/init.d/sensu-api stop
rabbitmqadmin delete queue name='results'
rabbitmqadmin delete queue name='keepalives'
```
