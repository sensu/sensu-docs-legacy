---
version: "0.16"
category: "Installation"
title: "Security"
---

# Security {#security}

Sensu leverages a set of services that need to be secured, each with
their own limitations and exposure.

This page provides information to help you secure your Sensu
installation.

## RabbitMQ {#rabbitmq}

Sensu leverages RabbitMQ authentication and SSL to secure
communication. You can learn about SSL certificate generation and
RabbitMQ's limitations [here](certificates). Sensu was designed to
deal with dynamic infrastructures, where it is not feasible to
maintain strict firewall rules. It is common to expose RabbitMQ's SSL
port (`5671`) without any restrictions, if peer verification is
enabled. Removing the default `guest` user and using randomly
generated user names and passwords is highly recommended.

## Redis {#redis}

Sensu uses Redis for storing data, a fantastic, simple data store,
that unfortunately doesn't provide proper authentication or SSL.
Securing Redis requires the use of strict firewall rules, which is
possible as the Sensu components that communicate with it are fairly
static. The default TCP port for Redis is `6379`, restricting access
to the port to certain hosts is recommended.
[Stunnel](http://www.stunnel.org) may be used to encrypt (SSL) Redis
traffic.

## Sensu API {#sensu-api}

The Sensu API provides basic HTTP authentication, but doesn't support
HTTPS (SSL). You may use a reverse proxy, such as
[Nginx](http://nginx.org/en/), to terminate SSL. The API listens on
TCP port `4567` by default, listening on all network interfaces.
