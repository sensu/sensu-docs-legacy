---
version: 0.17
category: "Installation Guide"
title: "Install Sensu"
next:
  url: "install-sensu-client"
  text: "Install Sensu Client"
info:
warning:
danger:
---

apt-get update
apt-get install sensu

yum install sensu


apt-get update
apt-get install sensu-enterprise

yum install sensu-enterprise


Connection information at `/etc/sensu/config.json`

{
  "rabbitmq": {
    "vhost": "/sensu",
    "user": "sensu",
    "password": "secret"
  },
  "redis": {
    "host": "localhost",
    "port": 6379
  }
}

wget http://sensuapp.org/docs/0.17/tools/check-mem.sh

Create a check at `/etc/sensu/conf.d/check_memory.json`

{
  "checks": {
    "memory": {
      "command": "/etc/sensu/plugins/check-mem.sh -w 120 -c 64",
      "interval" 10,
      "subscribers": [
        "test"
      ]
    }
  }
}

Create a default handler at `/etc/sensu/conf.d/default_handler.json`

{
  "handlers": {
    "default": {
      "type": "pipe",
      "command": "cat"
    }
  }
}


/etc/init.d/sensu-server start
/etc/init.d/sensu-api start

OR

/etc/init.d/sensu-enterprise start
