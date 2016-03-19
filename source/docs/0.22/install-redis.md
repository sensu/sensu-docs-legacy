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
and RHEL/CentOS operating systems, and via [Amazon Web Services][aws]
[ElastiCache][elasticache] service, only. Although it is possible to install and
run Redis on almost any modern operating system, all Sensu users are recommended
to use one of the following supported platforms.

To install Redis, please select one of the following:

- [Install Redis on Ubuntu/Debian](install-redis-on-ubuntu-debian)
- [Install Redis on RHEL/CentOS](install-redis-on-rhel-centos)
- [Install Redis on AWS (ElastiCache)](install-redis-using-aws-elasticache)

[redis]:            http://redis.io/
[redis-about]:      http://redis.io/topics/introduction
[support]:          https://sensuapp.org/support
[aws]:              http://aws.amazon.com/
[elasticache]:      https://aws.amazon.com/elasticache/
