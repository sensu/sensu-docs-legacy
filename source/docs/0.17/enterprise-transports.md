---
version: 0.17
category: "Enterprise Docs"
title: "Enterprise Transports"
---

# Overview

Sensu uses a message bus for communication. Until recently Sensu has been bound to RabbitMQ as the default and only message bus, but as of Sensu v0.13, the message bus integration has been decoupled to allow for alternate transport solutions to be used in place of RabbitMQ. Sensu Enterprise ships with support for RabbitMQ (default), and any broker that supports the [STOMP protocol][stomp], eg. [ActiveMQ][activemq].

# STOMP

## Install the STOMP transport

Sensu clients need to have the STOMP Sensu transport installed to be able to communicate with a STOMP broker. Sensu Enterprise already has the STOMP transport installed.

### Set Access Credentials

_NOTE: access to the Sensu Enterprise repositories requires an active [Sensu Enterprise](http://sensuapp.org/enterprise#pricing) subscription, and valid access credentials._

Please set the following environment variables, replacing `USER` and `PASSWORD` with the access credentials provided with your Sensu Enterprise subscription:

~~~ shell
export SE_USER=USER
export SE_PASS=PASSWORD
~~~

### Install the Sensu Enterprise Rubygem repository

Add the Sensu Enterprise Rubygem repository as a gem source for Sensu's embedded Ruby:

~~~ shell
sudo /opt/sensu/embedded/bin/gem sources --add "http://$SE_USER:$SE_PASS@enterprise.sensuapp.com/gem"
~~~

### Install the STOMP transport Rubygem

~~~ shell
sudo /opt/sensu/embedded/bin/gem install sensu-stomp
~~~

## Configure the STOMP transport

Configure Sensu services to use the STOMP transport, instead of RabbitMQ, with a JSON configuration file located at `/etc/sensu/conf.d/transport.json`.

~~~ json
{
  "transport": {
    "name": "stomp"
  }
}
~~~

Now configure the STOMP transport connection, using the definition attribute reference documentation below.

The following is an example STOMP transport configuration JSON configuration file, located at `/etc/sensu/conf.d/stomp.json.

~~~ json
{
  "stomp": {
    "host": "activemq.example.com",
    "port": 61612,
    "login": "sensu",
    "passcode": "97gdx9kaP71C",
    "ssl": {
      "cert_chain_file": "/etc/sensu/ssl/cert.pem",
      "private_key_file": "/etc/sensu/ssl/key.pem"
    }
  }
}
~~~

### Definition attributes

stomp
: description
  : A set of attributes that configure the STOMP transport connection.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "stomp": {}
    ~~~

#### Stomp attributes

host
: description
  : The STOMP broker host address.
: required
  : false
: type
  : String
: default
  : `localhost`
: example
  : ~~~ shell
    "host": "activemq.example.com"
    ~~~

port
: description
  : The STOMP broker port.
: required
  : false
: type
  : Integer
: default
  : `61613`
: example
  : ~~~ shell
    "port": 61612
    ~~~

login
: description
  : The STOMP broker login (username).
: required
  : false
: type
  : String
: default
  : `guest`
: example
  : ~~~ shell
    "login": "sensu"
    ~~~

passcode
: description
  : The STOMP broker passcode (password).
: required
  : false
: type
  : String
: default
  : `password`
: example
  : ~~~ shell
    "passcode": "secret"
    ~~~

ssl
: description
  : A set of attributes that configure SSL for the STOMP connection.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "ssl": {}
    ~~~

#### Stomp SSL attributes

cert_chain_file
: description
  : The local path of a readable file that contants a chain of X509 certificates in the PEM format, with the most-resolved certificate at the top of the file, successive intermediate certs in the middle, and the root (or CA) cert at the bottom.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "cert_chain_file": "/etc/sensu/ssl/cert.pem"
    ~~~

private_key_file
: description
  : The local path of a readable file that must contain a private key in the PEM format.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "private_key_file": "/etc/sensu/ssl/key.pem"
    ~~~

verify_peer
: description
  : If the STOMP broker certificate is to be verified.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "verify_peer": true
    ~~~

[stomp]: http://stomp.github.io
[activemq]: http://activemq.apache.org
