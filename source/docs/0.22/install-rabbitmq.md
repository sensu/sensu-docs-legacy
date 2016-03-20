---
version: 0.22
category: "Installation Guide"
title: "Install RabbitMQ"
---

# Install RabbitMQ

[RabbitMQ][rabbitmq] is a message bus that [describes itself][rabbitmq-features]
as _"a messaging broker - an intermediary for messaging. It gives your
applications a common platform to send and receive messages, and your messages a
safe place to live until received"_. RabbitMQ is also the default [Sensu
Transport](transport). When using RabbitMQ as the Sensu Transport, all Sensu
services require access to the same instance (or cluster) of RabbitMQ to
function.

[Sensu Support][support] is available for RabbitMQ installations on
Ubuntu/Debian and RHEL/CentOS operating systems, only. Although it is possible
to install and run Redis on almost any modern operating system, all Sensu users
are recommended to use one of the following supported platforms.

_NOTE: please refer to the [Installation Prerequisites documentation][prereqs]
regarding selecting a [Transport](transport) for your Sensu installation before
proceeding with RabbitMQ installation. If you intend to use Redis as your
transport, you don't need to install RabbitMQ._

- [Install RabbitMQ on Ubuntu/Debian](install-rabbitmq-on-ubuntu-debian)
- [Install RabbitMQ on RHEL/CentOS](install-rabbitmq-on-rhel-centos)

[prereqs]:            installation-prerequisites#selecting-a-transport
[rabbitmq]:           http://www.rabbitmq.com/
[rabbitmq-features]:  http://www.rabbitmq.com/features.html
[support]:            https://sensuapp.org/support
