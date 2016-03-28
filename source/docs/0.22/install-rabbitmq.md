---
version: 0.22
category: "Installation Guide"
title: "Install RabbitMQ"
---

# Install RabbitMQ

[RabbitMQ][1] is a message bus that [describes itself][rabbitmq-features] as _"a
messaging broker - an intermediary for messaging. It gives your applications a
common platform to send and receive messages, and your messages a safe place to
live until received"_. RabbitMQ is also the default [Sensu Transport][3]. When
using RabbitMQ as the Sensu Transport, all Sensu services require access to the
same instance (or cluster) of RabbitMQ to function.

[Sensu Support][4] is available for RabbitMQ installations on Ubuntu/Debian and
RHEL/CentOS operating systems, only. Although it is possible to install and run
Redis on almost any modern operating system, all Sensu users are recommended to
use one of the following supported platforms.

_NOTE: please refer to the [Installation Prerequisites documentation][5]
regarding selecting a [Transport][3] for your Sensu installation before
proceeding with RabbitMQ installation. If you intend to use Redis as your
transport, you don't need to install RabbitMQ._

- [Install RabbitMQ on Ubuntu/Debian](install-rabbitmq-on-ubuntu-debian)
- [Install RabbitMQ on RHEL/CentOS](install-rabbitmq-on-rhel-centos)

[1]:  http://www.rabbitmq.com/
[2]:  http://www.rabbitmq.com/features.html
[3]:  transport
[4]:  https://sensuapp.org/support
[5]:  installation-prerequisites#selecting-a-transport
