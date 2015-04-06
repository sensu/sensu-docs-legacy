---
version: 0.17
category: "Reference Docs"
title: "SSL Configuration"
---

# Overview

This reference document provides information to help you:

- Understand how Sensu uses SSL
- How to generate self-signed SSL certificates

# Sensu and SSL

All communication between Sensu services happens via the Sensu transport (RabbitMQ by default). As such, to secure a Sensu installation means to secure communication between all of the Sensu services and the Sensu transport via SSL encryption. Sensu can operate without the use of SSL encryption, however, this practice is heavily discouraged.

# Generate SSL certificates

The following instructions will generate an OpenSSL certificate authority and self-signed certificates.

## Install OpenSSL

OpenSSL is required on the machine that will generate the SSL certificates. Install OpenSSL on your platform:

### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get install openssl
openssl version
~~~

### CentOS/RHEL

~~~ shell
sudo yum install openssl
openssl version
~~~

## Download the Sensu SSL tool

Download the Sensu SSL tool (scripts):

~~~ shell
wget http://sensuapp.org/docs/0.17/files/sensu_ssl_tool.tar
tar -xvf sensu_ssl_tool.tar
~~~

## Generate the SSL certificates

Run the Sensu SSL tool to generate an OpenSSL certificate authority and self-signed certificates:

_NOTE: the generated certificates will be valid for 5 years._

~~~ shell
cd sensu_ssl_tool
./ssl_certs.sh generate
ls -l
~~~

## Limitations {#limitations}

You may have noticed that the instructions above only generated a single client certificate. Ideally, every SSL connection would use a different certificate, allowing them to be individually revoked. There is currently no way to tell RabbitMQ to reject a certificate. If the integrity of a certificate is compromised, it is common practice to regenerate and redistribute the certificate authority and certificates. This process is greatly simplified with the use of configuration management tools. In the future, the Sensu project hopes to be able to provide a better mechanism for distributing individual certificates and providing fast/simple revocation facilities.
