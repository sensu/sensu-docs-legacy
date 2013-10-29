---
layout: default
title: SSL Certificates
description: Discussion on SSL certificates and Sensu
version: '0.12'
---

# SSL Certificates

Use of SSL certificates in Sensu is optional but highly recommended. This document
contains a discussion on the limitations and workaround of SSL support within
Sensu in version 0.9

Below is a summary of the discussion captured in this thread: [Issue #434](https://github.com/sensu/sensu/issues/434)

## Limitations

You may have noticed the getting started guide includes code and guidance for
creating a simple CA and a single SSL key/cert for distributiong to all Sensu clients.
Ideally you would distribute individual certificates to each Sensu client and revoke
any certificate that was lost/stolen/etc.

However, Sensu's current SSL handling is implemented wholly within the RabbitMQ server
and thus the limitations of RabbitMQ (and Erlang, to an extent) are those of Sensu as well.

Specifically, there is no mechanism for revoking certificates.

## Workaround

While you could create individual certs for each Sensu client, if one of them was stolen
there is no way to tell the RabbitMQ server to ignore that certficiate. Instead, you would
need to create a new CA and sign new certificates for every client.

It is far easier to create a single certificate used by all Sensu clients at this time.
In the even the certificate is compromised, you would recreate the CA certificate and the client
certificate and distribute to your RabbitMQ brokers, Sensu servers, and Sensu clients.

Because Sensu is designed to pair well with modern configuration management tools such as
Chef and Puppet, it is assumed that most Sensu implementations are using one of these tools
and thus it should be a straightforward and relatively fast process to distribute new
certificates.

In the future we hope to be able to provide a better mechanism for distributing
individual certificates to each Sensu client and providing fast/simple revocation
facilities.
