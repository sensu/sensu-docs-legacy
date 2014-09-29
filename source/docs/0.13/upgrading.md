---
version: "0.13"
category: "Installation"
title: "Upgrading"
warning: "<strong>IMPORTANT NOTE:</strong> Sensu-Dashboard is no
longer included in the Sensu packages."
---

# Upgrading From 0.11-0.12 to 0.13 {#upgrading-from-0.11}

## Flush Redis {#flush-redis}

If you are upgrading Sensu from version 0.11.x or newer to 0.13,
you must flush the redis cache as the persistent data structures
have changed.

~~~ shell
redis-cli FLUSHALL
~~~

Do this *after* all of the clients have been upgraded.

## Update AMPQ Handler definitions

The configation for "exchange" type handlers have changed:

### Old

~~~ json
{
  "handlers": {
    "graphite": {
      "type": "amqp",
      "exchange": {
        "type": "topic",
        "name": "metrics",
        "durable": "true"
      },
      "mutator": "only_check_output"
    }
  }
}
~~~

### New

~~~ json
{
  "handlers": {
    "graphite": {
      "type": "transport",
      "pipe": {
        "type": "topic",
        "name": "metrics",
        "durable": "true"
      },
      "mutator": "only_check_output"
    }
  }
}
~~~

# Upgrading From 0.10.x {#upgrading-from-0.10}

If you are upgrading Sensu from version 0.10.x or earlier, you will
need to stop the Sensu server and API services, and then delete the
result and keepalive queues from RabbitMQ before the upgrade. You will
need to have `rabbitmqadmin` installed to do this.

### Step #1 - Stop the Sensu servers {#stop-the-sensu-servers}

~~~ shell
sudo /etc/init.d/sensu-server stop
~~~

### Step #2 - Stop the Sensu APIs {#stop-the-sensu-apis}

~~~ shell
sudo /etc/init.d/sensu-api stop
~~~

### Step #3 - Delete the RabbitMQ queues {#delete-the-rabbitmq-queues}

Run this on the RabbitMQ system.

You may need to specify the Sensu RabbitMQ vhost (`--vhost=`), user
(`--username=`), and password (`--password=`).

For help, run `rabbitmqadmin --help`.

~~~ shell
rabbitmqadmin delete queue name='results'
rabbitmqadmin delete queue name='keepalives'
~~~

### Step #4 - Clear redis of old data:

~~~ shell
redis-cli FLUSHALL
~~~

### Step #5 - Upgrade the package(s) {#upgrade-the-sensu-packages}

Upgrade the Sensu package and restart the Sensu services.
