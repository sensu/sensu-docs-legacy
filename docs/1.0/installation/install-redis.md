---
title: "Install Redis"
description: "The complete Sensu installation guide."
version: 0.29
weight: 0
hidden: true
next:
  url: install-redis-on-ubuntu-debian.html
  label: "Install Redis on Ubuntu/Debian"
---

# Install Redis

[Redis][1] is a key-value database, which [describes itself][2] as _"an open
source, BSD licensed, advanced key-value cache and store"_. Sensu uses Redis for
storing persistent data. Two Sensu services, the server and API, require access
to the same instance of Redis to function.  Although it is possible to install
and run Redis on almost any modern operating system, **all Sensu users are
encouraged to install and run Redis on one of the following _supported_
platforms**:

- [Install Redis on Ubuntu/Debian](install-redis-on-ubuntu-debian.html) (recommended)
- [Install Redis on RHEL/CentOS](install-redis-on-rhel-centos.html)

Amazon Web Services [ElastiCache][5] with Redis 2.8.x may be used to
provide Redis service for Sensu. See Amazon's
[Getting Started with Amazon ElastiCache guide][6] for details on
provisioning ElastiCache in AWS. Once provisioned in AWS, Sensu can be
configured to use the ElastiCache endpoint address and port.

_WARNING: [Sensu Support][3] is available for Redis installations on
Ubuntu/Debian and RHEL/CentOS operating systems, and via [Amazon Web
Services][4] [ElastiCache][5], **only**._

[1]:  http://redis.io/
[2]:  http://redis.io/topics/introduction
[3]:  https://sensuapp.org/support
[4]:  http://aws.amazon.com/
[5]:  https://aws.amazon.com/elasticache/
[6]:  http://docs.aws.amazon.com/AmazonElastiCache/latest/UserGuide/GettingStarted.html
