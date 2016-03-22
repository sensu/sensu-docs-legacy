---
version: 0.22
category: "Installation Guide"
title: "The five minute install"
---

# The five minute Sensu Install

## Objective

Although Sensu’s [architecture](architecture) is one of its most compelling
features, and the [complete installation guide](installation-guide) can help you
get Sensu installed and configured for [a variety of operating
environments](installation-strategies), you might not actually care about any of
that until you can get Sensu up and running in a development environment for
testing purposes. This installation guide is intended to help you to **install
Sensu in five minutes or less, or we'll give you your money back, guaranteed**.

After completing the steps in this guide, you will have a fully functional Sensu
Core installation in a [standalone][standalone] configuration.

## Installation Requirements

What will you need to complete this guide?

- A virtual machine, or physical computer running 64-bit
  [Ubuntu 14.04][ubuntu1404] with a minimum of 2GB of memory (4GB recommended)
- Familiarity with a modern command-line interface
- 300 seconds (the amount of time it should take to complete this installation
  guide)

Ready? Let's get started!

## Install Sensu in 5-minutes or less {#install-sensu}

The following installation steps will help you get Sensu Core installed in a
[standalone][standalone] on a system running [Ubuntu 14.04][ubuntu1404], only.
For installation on other platforms, and/or alternative installation
configurations, please consult the [installation guide](installation-guide).

1. Install Redis (>= 1.3.14) from the distribution repository:

   ~~~ shell
   sudo apt-get update
   sudo apt-get -y install redis-server curl jq
   ~~~

2. Install the Redis init scripts using the `update-rc.d` utility, and start
   Redis:

   ~~~ shell
   sudo update-rc.d redis-server defaults
   sudo /etc/init.d/redis-server start
   ~~~

3. Download and install Sensu using `wget` and `dpkg`:

   ~~~ shell
   wget https://core.sensuapp.com/apt/pool/sensu/main/s/sensu/sensu_0.22.1-1_amd64.deb
   sudo dpkg -i sensu_0.22.1-1_amd64.deb
   ~~~

   Verify that Sensu is installed by running the following command:

   ~~~ shell
   /opt/sensu/bin/sensu-server --version
   ~~~

4. Configure Sensu by downloading this [example configuration
   file][simple-sensu-config]:

   ~~~ shell
   sudo wget -O /etc/sensu/config.json http://sensuapp.org/docs/0.22/files/simple-sensu-config.json
   ~~~

   Alternatively, please copy the following example configuration file contents
   to `/etc/sensu/config.json`:

   ~~~ shell
   {
     "redis": {
       "host": "localhost"
     },
     "transport": {
       "name": "redis"
     },
       "api": {
       "host": "localhost",
       "port": 4567
     }
   }
   ~~~

5. Configure the Sensu client by downloading this [example configuration
   file][simple-client-config]:

   ~~~ shell
   sudo wget -O /etc/sensu/conf.d/client.json http://sensuapp.org/docs/0.22/files/simple-client-config.json
   ~~~

   Alternatively, please copy the following example configuration file contents
   to `/etc/sensu/conf.d/client.json`:

   ~~~ shell
   {
     "client": {
       "name": "test",
       "address": "localhost",
       "environment": "development",
       "subscriptions": [
         "dev"
       ]
     }
   }
   ~~~

6. Make sure that the `sensu` user owns all of the Sensu configuration files:

   ~~~ shell
   sudo chown -R sensu:sensu /etc/sensu
   ~~~

7. Start the Sensu services

   ~~~ shell
   sudo /etc/init.d/sensu-server start
   sudo /etc/init.d/sensu-api start
   sudo /etc/init.d/sensu-client start
   ~~~

8. Verify that your installation is ready to use by querying the Sensu API
   using the `curl` utility (and piping the result to `jq`):

   ~~~ shell
   curl http://localhost:4567/clients | jq .
   ~~~

   If the Sensu API returns a JSON array of Sensu clients similar to this:

   ~~~ shell
   $ curl http://localhost:4567/clients | jq .
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100   175  100   175    0     0  26014      0 --:--:-- --:--:-- --:--:-- 29166
   [
     {
       "timestamp": 1458625739,
       "version": "0.22.1",
       "socket": {
         "port": 3030,
         "bind": "127.0.0.1"
       },
       "subscriptions": [
         "dev"
       ],
       "environment": "development",
       "address": "localhost",
       "name": "test"
     }
   ]
   ~~~

   ...you have successfully installed and configured Sensu!

## Next Steps

Coming soon...

[ubuntu1404]:             http://releases.ubuntu.com/14.04/
[standalone]:             installation-strategies#standalone
[simple-sensu-config]:    /docs/0.22/files/simple-sensu-config.json
[simple-client-config]:   /docs/0.22/files/simple-client-config.json
