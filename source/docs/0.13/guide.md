---
version: "0.13"
category: "Installation"
title: "Guide"
next:
  url: adding_a_check
  text: "Adding a check"
---

# Guide {#guide}

This guide provides instructions on how to manually install and
configure Sensu and its dependencies on Linux.

Sensu is typically (and best!) deployed by a configuration management
tool, such as Chef and Puppet.

* [Chef cookbook](https://github.com/sensu/sensu-chef)
* [Puppet module](https://github.com/sensu/sensu-puppet)

## Introduction {#introduction}

We will use two systems, one will run all of the Sensu components, and
the other will only run the Sensu client. You may choose to only
configure the system running all of the components, since it does run
a Sensu client. We'll name our systems "monitor" and "agent".

#### Monitor {#monitor}

- RabbitMQ
- Redis
- Sensu server
- Sensu client
- Sensu API
- Sensu Dashboard

#### Agent {#agent}

- Sensu client

### Install Sensu server dependencies {#install-sensu-server-dependencies}

On the "monitor" system, generate SSL certificates for Sensu, using
the following instructions.

- [Generating SSL certificates](certificates)

On the "monitor" system, install RabbitMQ and Redis, using the
following instructions.

- [Installing RabbitMQ](rabbitmq)
- [Installing Redis](redis)

### Install Sensu {#install-sensu}

On both systems, install Sensu using the following instructions.

- [Installing Sensu](packages)


### Configure Sensu connections {#configure-sensu-connections}

Both systems run Sensu components that need to talk to RabbitMQ, so
we'll provide Sensu with connection information.

Earlier, you generated SSL certificates for Sensu on "monitor", and
used them when configuring RabbitMQ. The Sensu components will use the
client certificate that was generated.

On both systems, create an SSL directory for the Sensu components.

~~~ shell
mkdir -p /etc/sensu/ssl
~~~

Copy the following generated SSL files to the newly created SSL
directories.

* `client/cert.pem`
* `client/key.pem`

On both systems, create/edit `/etc/sensu/conf.d/rabbitmq.json`, you
will need to substitute a few values.

~~~ json
{
  "rabbitmq": {
    "ssl": {
      "cert_chain_file": "/etc/sensu/ssl/cert.pem",
      "private_key_file": "/etc/sensu/ssl/key.pem"
    },
    "host": "SUBSTITUTE_ME",
    "port": 5671,
    "vhost": "/sensu",
    "user": "sensu",
    "password": "SUBSTITUTE_ME"
  }
}
~~~

The "monitor" system runs the Sensu server and API, which need to talk
to Redis, so we'll provide Sensu with connection information.

On the "monitor" system, create/edit `/etc/sensu/conf.d/redis.json`.

~~~ json
{
  "redis": {
    "host": "localhost",
    "port": 6379
  }
}
~~~

### Configure the Sensu API and dashboard {#configure-the-sensu-api-and-dashboard}

The "monitor" system runs the Sensu API and dashboard, so we'll need
to configure them.

On the "monitor" system, create/edit `/etc/sensu/conf.d/api.json`.

~~~ json
{
  "api": {
    "host": "localhost",
    "port": 4567,
    "user": "admin",
    "password": "secret"
  }
}
~~~

On the "monitor" system, create/edit `/etc/sensu/conf.d/dashboard.json`.

~~~ json
{
  "dashboard": {
    "port": 8080,
    "user": "admin",
    "password": "secret"
  }
}
~~~

### Configure the Sensu clients {#configure-the-sensu-clients}

On both systems, configure the Sensu client, providing them with
information about themselves.

The Sensu client name is commonly the system's hostname, or another
unique identifier (such as a VM ID).

On both systems, create/edit `/etc/sensu/conf.d/client.json`.

~~~ json
{
  "client": {
    "name": "SUBSTITUTE_ME",
    "address": "SUBSTITUTE_ME",
    "subscriptions": [ "all" ]
  }
}
~~~

### Enable Sensu services {#enable-sensu-services}

The Sensu packages install sysvinit (init.d) scripts directly to
`/etc/init.d/`. All services are disabled by default.

Alternative supervisor scripts (such as upstart) are available in
`/usr/share/sensu` for those that may want them.

#### "Monitor" system {#enable-monitor-system-services}

On the "monitor" system, enable all of the Sensu components.

##### Debian and Ubuntu {#monitor-system-services-debian-and-ubuntu}

~~~ shell
update-rc.d sensu-server defaults
update-rc.d sensu-client defaults
update-rc.d sensu-api defaults
update-rc.d sensu-dashboard defaults
~~~

##### CentOS (RHEL) {#monitor-system-services-centos-and-rhel}

~~~ shell
chkconfig sensu-server on
chkconfig sensu-client on
chkconfig sensu-api on
chkconfig sensu-dashboard on
~~~

#### "Agent" system {#enable-agent-system-services}

On the "agent" system, enable the Sensu client.

##### Debian and Ubuntu {#agent-system-services-debian-and-ubuntu}

~~~ shell
update-rc.d sensu-client defaults
~~~

##### CentOS (RHEL) {#agent-system-services-debian-and-ubuntu}

~~~ shell
chkconfig sensu-client on
~~~

### Start Sensu services {#start-sensu-services}

#### "Monitor" system {#start-monitor-system-services}

On the "monitor" system, start all of the Sensu components.

~~~ shell
/etc/init.d/sensu-server start
/etc/init.d/sensu-client start
/etc/init.d/sensu-api start
/etc/init.d/sensu-dashboard start
~~~

#### "Agent" system {#start-agent-system-services}

On the "agent" system, start the Sensu client.

~~~ shell
/etc/init.d/sensu-client start
~~~

### Dashboard {#dashboard}

The Sensu dashboard should now be accessible on the "monitor" system,
`http://admin:secret@SUBSTITUTE_ME:8080`.

Log files for Sensu components are available in `/var/log/sensu`.

## Next Steps {#next-steps}

Now that you have a running Sensu installation, the next steps are to
add monitoring checks and event handlers.

If you have further questions please visit the `#sensu` IRC channel on
Freenode or send an email to the `sensu-users` mailing list.
