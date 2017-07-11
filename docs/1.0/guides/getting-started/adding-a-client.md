---
title: "Adding a Client"
version: 1.0
weight: 2
next:
  url: "intro-to-checks.html"
  text: "An intro to checks"
---

**Sensu clients** are pieces of infrastructure that Sensu monitors for you. The **Sensu client software** allows you to register a running instance of itself as capable of running any **checks** they might be eligible for.

Infrastructure sometimes includes hardware or services that don't necessarily support running the **Sensu client software** but still needs to be monitored. For those cases, [**proxy clients**](#proxy-clients) let you monitor anything you can tell Sensu about.

# Adding a Sensu Client

One of the first challenges new Sensu users often encounter is learning what
is required to get a remote [Sensu client][1] to communicate with the [Sensu
server][2]. If you're in a hurry, skip ahead to [add a remote Sensu client][3]
for step-by-step instructions.

Alternatively, once you understand the **two requirements** for adding Sensu
clients, you'll know everything you need to start deploying Sensu clients to
your entire infrastructure. Please continue reading to learn how adding Sensu
clients [starts with configuration][4] and is ultimately [all about the
transport][5].

## It starts with configuration

Sensu is designed to be operated via configuration. This core philosophy is what
enables Sensu to work so seamlessly with modern automation solutions and
configuration management platforms. To learn more about how Sensu is configured,
please consult the [Sensu configuration reference documentation][6].

The Sensu client requires a minimal amount of configuration to enable it to
[automatically register itself][7] with the Sensu server, which configuration
includes a [client definition][8] (e.g. the client `name`, `address`, and
`subscriptions`), and a [transport definition][9].

## It's all about the transport

The Sensu processes use a [transport][10] (a message bus) for communication. By
default this is [RabbitMQ][11], but modern versions of Sensu have added support
for [alternative transports][12] including [Redis][13]. Without a transport
connection, a Sensu client will be unable to send monitoring data (e.g.
[keepalive messages][14], [check results][15], etc). In order to  connect to the
transport, the Sensu client will need three pieces of information:

- Which transport to use (this tells Sensu which transport library should it
  load, and which configuration scope should it use to obtain connection
  details)
- A valid transport definition (this provides Sensu with an IP address or
  hostname, and any security credentials needed to connect to the transport)
- Network access to the transport socket (i.e. the Sensu client will need
  outbound network access, and the transport will need to be configured to
  listen for remote network connections)

## Add a remote Sensu client

With the exception of Sensu clients that are running on the Sensu server (which
is very useful and strongly recommended), all Sensu clients are essentially
"remote clients" as they have to establish network communication to send
monitoring data (e.g. [client keepalives][14] and [check results][15]). Please
note the following steps that are required to add a remote Sensu client:

1. **Configure the client**. Create a client definition, located at
   `/etc/sensu/conf.d/client.json` with the following contents (replacing the
   values for the client `name`, `address`, and `subscriptions` with the
   corresponding values for the client you are adding):

   ~~~ json
   {
     "client": {
       "name": "i-041256",
       "address": "8.8.8.8",
       "subscriptions": [
         "default",
         "webserver"
       ]
     }
   }
   ~~~

2. **Tell the client which transport to use**. Create a transport definition at
   `/etc/sensu/conf.d/transport.json` with the following contents (replacing the
   value for the transport `name` with the corresponding value for the transport
   you are using; e.g. use `"transport": "redis"` if you are using the Redis
   transport).

   ~~~ json
   {
     "transport": {
       "name": "rabbitmq",
       "reconnect_on_error": true
     }
   }
   ~~~

3. **Tell the client how to connect to the transport**. Create a transport
   definition at `/etc/sensu/conf.d/rabbitmq.json` (or
   `/etc/sensu/conf.d/redis.json` if you are using the Redis transport).

   _NOTE: please consult the corresponding reference documentation for
   [RabbitMQ][11] or [Redis][13] for more configuration examples and detailed
   information on how to configure Sensu's connection._

4. **Start the client**
   Start the Sensu client and verify connectivity by consulting the Sensu client
   log file:

   _NOTE: The `service` command will not work on CentOS 5, the
   sysvinit script must be used, e.g. `sudo /etc/init.d/sensu-client start`_

   ~~~ shell
   sudo service sensu-client start
   ~~~

## Proxy Clients

Sometimes, a logical piece of infrastructure isn't a device we can run Sensu on. Fundamentally, Sensu gives you the flexibility to separate **how** checks run from **where** they run, which lets you monitor arbitrary, named 'black box' devices or services.

For example, you may have a router that you can't run Sensu on but publishes interesting information over SNMP that you want to gather metrics from. Or maybe your monitor which other datacenters are visible/online to you, or have any number of creative use cases. You can create a [**proxy client**][16] that can have attributes for use in check execution, allowing you to use the **client registry** naturally for 'managed' an 'unmanaged' infrastructure. See [the reference for creating proxy clients][16] or [details on writing checks against them][17] for more.

## Troubleshooting


[?]:  #
[1]:  ../../reference/clients.html
[2]:  ../../reference/server.html
[3]:  #add-a-remote-sensu-client
[4]:  #it-starts-with-configuration
[5]:  #its-all-about-the-transport
[6]:  ../../reference/configuration.html
[7]:  ../../reference/clients.html#registration-and-registry
[8]:  ../../reference/clients.html#client-definition-specification
[9]:  ../../reference/transport.html#transport-definition-specification
[10]: ../../reference/transport.html
[11]: ../../reference/rabbitmq.html
[12]: ../../reference/transport.html#selecting-a-transport
[13]: ../../reference/redis.html
[14]: ../../reference/clients.html#client-keepalives
[15]: ../../reference/checks.html#check-results
[16]: ../../reference/clients.html#proxy-clients
[17]: intro-to-checks.html#proxy-clients
