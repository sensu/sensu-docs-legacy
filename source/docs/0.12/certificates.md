---
version: "0.12"
category: "Installation"
title: "SSL certificates"
next:
  url: rabbitmq
  text: "RabbitMQ"
---

# SSL certificates

Sensu uses SSL for secure communication between components and
RabbitMQ. It is possible to use Sensu without SSL, however, it is
heavily discouraged. The following instructions use a tool to generate
self-signed OpenSSL certificates, but you can also use the
instructions available on the RabbitMQ SSL
[page](http://www.rabbitmq.com/ssl.html).

## Create an authority and certificates

You may run the following on any system that has the OpenSSL tools
installed.

The created authority and certificates will be used and referenced in
other installation and configuration instructions.

Be sure that OpenSSL is installed.

~~~ shell
which openssl
openssl version
~~~

The following will create a certificate authority, and generate
certificates that will be valid for `1825` days, or `5` years.

~~~ shell
cd /tmp
wget http://sensuapp.org/docs/0.12/tools/ssl_certs.tar
tar -xvf ssl_certs.tar
cd ssl_certs
./ssl_certs.sh generate
~~~

## Limitations

Below is a summary of the discussion captured in this thread: [Issue
\#434](https://github.com/sensu/sensu/issues/434)

You may have noticed that the instructions above only generated a
single client certificate. Ideally, every SSL connection would use a
different certificate, allowing them to be individually revoked. There
is currently no way to tell RabbitMQ to reject a certificate. If the
integrity of a certificate is compromised, its common practice to
regenerate and redistribute the certificate authority and
certificates. This process is greatly simplified with the use of
configuration management tools. In the future, the Sensu project hopes
to be able to provide a better mechanism for distributing individual
certificates and providing fast/simple revocation facilities.
