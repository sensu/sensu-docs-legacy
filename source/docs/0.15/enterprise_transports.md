---
version: "0.15"
category: "Enterprise"
title: "Transports"
---

# Enterprise transports

Sensu relies on a message bus for communication. Until recently Sensu
has been bound to RabbitMQ as the default and only message bus, but as
of Sensu v0.13, the message bus integration has been decoupled to
allow for alternate transport solutions to be used in place of
RabbitMQ. Sensu Enterprise ships with support for RabbitMQ (default),
and any broker that supports the [STOMP protocol][stomp], eg.
[ActiveMQ][activemq].

## STOMP transport

~~~ json
{
    "stomp": {
        "host": "activemq.example.com",
        "port": 61612,
        "ssl": {
            "cert_chain_file": "/etc/sensu/ssl/cert.pem",
            "private_key_file": "/etc/sensu/ssl/key.pem"
        }
    }
}
~~~

[stomp]: http://stomp.github.io
[activemq]: http://activemq.apache.org
