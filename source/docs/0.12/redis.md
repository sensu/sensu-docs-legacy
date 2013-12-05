---
version: "0.12"
category: "Installation"
title: "Redis"
---

# Redis

A few Sensu components require access to an instance of Redis, for
storing persistent data.

## Install Redis on Debian and Ubuntu

#### Debian 6.x

Add Debian backports to APT sources.

``` shell
echo "deb http://backports.debian.org/debian-backports squeeze-backports main contrib non-free" >> /etc/apt/sources.list
```

Install Redis from Debian backports.

``` shell
apt-get update
apt-get -t squeeze-backports install redis-server
```

#### Ubuntu <= 10.04

You will need to download and install Redis 2.0+ from source for these
releases.

#### Ubuntu > 10.04

``` shell
apt-get update
apt-get install redis-server
```

## Install Redis on CentOS (RHEL)

### Step #1 - Install EPEL

#### CentOS 5

``` shell
rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm
```

#### CentOS 6

``` shell
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
```

### Step #2 - Install Redis

``` shell
yum install redis
```

Set Redis to start on boot and start it up:

```
/sbin/chkconfig redis on
/etc/init.d/redis start
```
