---
version: "0.16"
category: "Installation"
title: "Redis"
next:
  url: packages
  text: "Sensu packages"
---

# Redis {#redis}

A few Sensu components require access to an instance of Redis, for
storing persistent data.

## Install Redis on Debian and Ubuntu {#install-redis-on-debian-and-ubuntu}

#### Debian 6.x {#install-redis-debian6x}

Add Debian squeeze-backports to APT sources.

~~~ shell
echo "deb http://http.debian.org/debian-backports squeeze-backports main" >> /etc/apt/sources.list
~~~

Install Redis from Debian Squeeze backports.

~~~ shell
apt-get update
apt-get -t squeeze-backports install redis-server
~~~

#### Debian 7.x {#install-redis-debian7x}

Add Debian wheezy-backports to APT sources.

~~~ shell
echo "deb http://http.debian.org/debian-backports wheezy-backports main" >> /etc/apt/sources.list
~~~

Install Redis from Debian Wheezy backports.

~~~ shell
apt-get update
apt-get -t wheezy-backports install redis-server
~~~

#### Ubuntu <= 10.04 {#install-redis-ubuntu-1004-and-earlier}

You will need to download and install Redis 2.0+ from source for these
releases.

#### Ubuntu > 10.04 {#install-redis-ubuntu-newer-than-1004}

~~~ shell
apt-get update
apt-get install redis-server
~~~

## Install Redis on CentOS (RHEL) {#install-redis-on-centos-and-rhel}

### Step #1 - Install EPEL

#### CentOS 5 {#install-redis-centos5}

~~~ shell
rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
~~~

#### CentOS 6 {#install-redis-centos6}

~~~ shell
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
~~~

### Step #2 - Install Redis {#centos-rhel-install-redis}

~~~ shell
yum install redis
~~~

Set Redis to start on boot and start it up:

For Debian/Ubuntu:

~~~ shell
update-rc.d redis-server defaults
/etc/init.d/redis-server start
~~~

For CentOS:

~~~
/sbin/chkconfig redis on
/etc/init.d/redis start
~~~
