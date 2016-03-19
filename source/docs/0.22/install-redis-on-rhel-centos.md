---
version: 0.22
category: "Installation Guide"
title: "Install Redis on RHEL/CentOS"
next:
  url: "install-rabbitmq"
  text: "Install RabbitMQ"
---

# Install Redis on RHEL/CentOS

- [Install Redis from the EPEL repositories](#install-redis-from-the-epel-repositories)
- [Managing the Redis service/process](#manage-the-redis-service-process)
- [Verify that Redis is working](#verify-that-redis-is-working)

## Install Redis from the EPEL repositories

Because Redis is not available by default in all RHEL and CentOS distribution
repositories, you will need to install the corresponding [EPEL][epel] repository
[for your CentOS/RHEL release][epel-howto] (supported platforms are RHEL 5, RHEL
6, and RHEL 7).

1. Install EPEL on RHEL/CentOS 6:

   ~~~ shell
   sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
   ~~~

   _NOTE: the preceding command will install the EPEL repository for
   RHEL/CentOS **version 6 ONLY**. For other RHEL/CentOS releases (i.e. version
   5 or 7), please refer to the [intructions for installing the correct EPEL for
   your release][epel-howto]._

2. Install Redis using YUM

   Install Redis (>= 1.3.14) from the EPEL repository:

   ~~~ shell
   sudo yum install redis
   ~~~

## Managing the Redis service/process

Install the Redis init scripts using the [`chkconfig` utility][chkconfig]:

~~~ shell
sudo /sbin/chkconfig redis on
sudo /etc/init.d/redis start
~~~

## Verify that Redis is working

Once you have installed and started the Redis service, you should be able to
confirm that Redis is ready to use by running the command:  <kbd>redis-cli
ping</kbd>. If you get a `PONG` response, you are ready to move on to the next
step in the guide.


[epel]:         https://fedoraproject.org/wiki/EPEL
[epel-howto]:   http://fedoraproject.org/wiki/EPEL/FAQ#howtouse
[chkconfig]:    https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-services-chkconfig.html
