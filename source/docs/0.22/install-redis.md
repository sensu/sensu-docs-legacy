---
version: 0.22
category: "Installation Guide"
title: "Install Redis"
---

# Install Redis

[Redis][redis] is a key-value database, which [describes itself][redis-about] as
_"an open source, BSD licensed, advanced key-value cache and store"_. Sensu uses
Redis for storing persistent data. Two Sensu services, the server and API,
require access to the same instance of Redis to function.

[Sensu Support][support] is available for Redis installations on Ubuntu/Debian
and RHEL/CentOS operating systems, only. Although it is possible to install and
run Redis on almost any modern operating system, all Sensu users are recommended
to install Redis on Ubuntu/Debian or RHEL/CentOS based systems.

To install Redis, please select one of the following:

- [Install Redis on Ubuntu/Debian](install-redis-on-ubuntu-debian)
- [Install Redis on RHEL/CentOS](install-redis-on-rhel-centos)

[redis]:            http://redis.io/
[redis-about]:      http://redis.io/topics/introduction
[support]:          https://sensuapp.org/support
