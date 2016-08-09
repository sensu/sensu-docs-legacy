---
version: 0.18
category: "Reference Docs"
title: "RabbitMQ Configuration"
next:
  url: "redis"
  text: "Redis Configuration"
---

# Overview

This reference document provides information to help you:

- Understand what RabbitMQ is
- Understand how Sensu uses RabbitMQ
- How to configure the Sensu RabbitMQ connection
- How to configure RabbitMQ
- How to secure RabbitMQ in production

# What is RabbitMQ?

RabbitMQ is a message bus, which [describes itself](http://www.rabbitmq.com/features.html) as _"a messaging broker - an intermediary for messaging. It gives your applications a common platform to send and receive messages, and your messages a safe place to live until received"_.

You can visit the official RabbitMQ website to learn more: [rabbitmq.com](http://www.rabbitmq.com/)

# How Sensu uses RabbitMQ

Sensu services use RabbitMQ (the default Sensu transport) to communicate with one another. Every Sensu service requires access to the same instance of RabbitMQ or a RabbitMQ cluster to function. Sensu check requests and check results are sent over RabbitMQ to the approprate Sensu services.

# Anatomy of a RabbitMQ definition

The RabbitMQ definition uses the `"rabbitmq": {}` definition scope.

### Definition attributes

host
: description
  : The RabbitMQ hostname or IP address (recommended).
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

port
: description
  : The RabbitMQ TCP port.
: required
  : false
: type
  : Integer
: default
  : `5672`
: example
  : ~~~ shell
    "port": 5671
    ~~~

vhost
: description
  : The RabbitMQ vhost to use.
: required
  : false
: type
  : String
: default
  : `/`
: example
  : ~~~ shell
    "vhost": "/sensu"
    ~~~

user
: description
  : The RabbitMQ user name.
: required
  : false
: type
  : String
: default
  : `guest`
: example
  : ~~~ shell
    "user": "sensu"
    ~~~

password
: description
  : The RabbitMQ user password.
: required
  : false
: type
  : String
: default
  : `guest`
: example
  : ~~~ shell
    "password": "secret"
    ~~~

ssl
: description
  : A set of attributes that configure SSL encryption for the connection. SSL encryption will be enabled if this option is configured.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "ssl": {}
    ~~~

#### SSL attributes

The following attributes are configured within the `"ssl": {}` RabbitMQ definition attribute scope.

cert_chain_file
: description
  : The file path for the chain of X509 SSL certificates in the PEM format for the SSL connection.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "cert_chain_file": "/etc/sensu/ssl/cert.pem"
    ~~~

private_key_file
: description
  : The file path for the SSL private key in the PEM format.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "private_key_file": "/etc/sensu/ssl/key.pem"
    ~~~

# Configuring RabbitMQ

To configure RabbitMQ, please refer to the [official RabbitMQ configuration documentation](https://www.rabbitmq.com/configure.html).

# Security

Sensu leverages RabbitMQ access control and SSL for secure communication. Sensu was created to deal with dynamic infrastructure, where it is not feasible to maintain strict firewall rules. It is common to expose RabbitMQ’s SSL port (`5671`) without any restrictions, if certain conditions are met. Removing the default RabbitMQ user `guest` is mandatory and using a generated user name, password, and vhost is highly recommended. Enabling SSL peer certificate verification will ensure only trusted RabbitMQ clients with the correct private key are able to connect.
