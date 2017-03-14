---
title: "The Five Minute Install"
version: 0.24
weight: 1
next:
  url: "learn-sensu-basics.html"
  text: "Learn Sensu in 15 minutes"
---

# The Five Minute Install

## Objective

Although Sensu’s [architecture][1] is one of its most compelling features, and
the [complete installation guide][2] can help you get Sensu installed and
configured for [a variety of operating environments][3], you might not actually
care about any of that until you can get Sensu up and running in a development
environment for testing purposes. This installation guide is intended to help
you to **install Sensu Core in five minutes or less, <abbr title='all $0 of it
you paid for that "free as in beer" open source software :)'>or we'll give you
your money back</abbr>, guaranteed**.

After completing the steps in this guide, you will have a fully functional Sensu
Core installation in a [standalone][4] configuration.

## Installation Requirements

What will you need to complete this guide?

- A virtual machine, or physical computer running 64-bit
  [Ubuntu 14.04][5] with a minimum of 2GB of memory (4GB recommended)
- Familiarity with a <abbr title='do you even pipe to grep?!'>command-line
  interface</abbr>
- Willingness to run a [shell script downloaded from the internet][6]
  ([or not][7])
- The commitment to count to [ten][8] (the number of steps in this guide)
- 300 seconds (the amount of time it should take to complete this installation)

Ready? Let's get started!

## Install Sensu in 5-minutes or less {#install-sensu}

The following installation steps will help you get Sensu Core installed in a
[standalone][4] on a system running [Ubuntu 14.04][5], only. For installation on
other platforms, and/or alternative installation configurations, please consult
the [installation guide](2).

1. Install the Sensu software repositories:

   ~~~ shell
   wget https://sensuapp.org/install.sh
   sudo bash install.sh
   sudo apt-get update
   ~~~

2. Install Redis (>= 1.3.14) from the distribution repository:

   ~~~ shell
   sudo apt-get -y install redis-server curl jq
   ~~~

3. Install the Redis init scripts using the `update-rc.d` utility, and start
   Redis:

   ~~~ shell
   sudo update-rc.d redis-server defaults
   sudo /etc/init.d/redis-server start
   ~~~

4. Install Sensu

   ~~~ shell
   sudo apt-get install sensu
   ~~~

   ...and if you're using [Sensu Enterprise][9], let's go ahead and install
   Sensu Enterprise as well:

   ~~~ shell
   sudo apt-get install sensu-enterprise sensu-enterprise-dashboard
   ~~~

5. Configure Sensu by downloading this [example configuration file][10]:

   ~~~ shell
   sudo wget -O /etc/sensu/config.json https://sensuapp.org/docs/0.24/files/simple-sensu-config.json
   ~~~

   Alternatively, please copy the following example configuration file contents
   to `/etc/sensu/config.json`:

   ~~~ shell
   {
     "redis": {
       "host": "127.0.0.1"
     },
     "transport": {
       "name": "redis"
     },
     "api": {
       "host": "127.0.0.1",
       "port": 4567
     }
   }
   ~~~

6. Configure the Sensu client by downloading this [example configuration
   file][11]:

   ~~~ shell
   sudo wget -O /etc/sensu/conf.d/client.json https://sensuapp.org/docs/0.24/files/simple-client-config.json
   ~~~

   Alternatively, please copy the following example configuration file contents
   to `/etc/sensu/conf.d/client.json`:

   ~~~ shell
   {
     "client": {
       "name": "client-01",
       "address": "127.0.0.1",
       "environment": "development",
       "subscriptions": [
         "dev"
       ],
       "socket": {
         "bind": "127.0.0.1",
         "port": 3030
       }
     }
   }
   ~~~

7. Configure a Sensu dashboard by downloading this [example configuration
   file][12]:

   ~~~ shell
   sudo wget -O /etc/sensu/dashboard.json https://sensuapp.org/docs/0.24/files/simple-dashboard-config.json
   ~~~

   Alternatively, please copy the following example configuration file contents
   to `/etc/sensu/dashboard.json`:

   ~~~
   {
     "sensu": [
       {
         "name": "sensu",
         "host": "127.0.0.1",
         "port": 4567
       }
     ],
     "dashboard": {
       "host": "0.0.0.0",
       "port": 3000
     }
   }
   ~~~

8. Make sure that the `sensu` user owns all of the Sensu configuration files:

   ~~~ shell
   sudo chown -R sensu:sensu /etc/sensu
   ~~~

9. Start the Sensu services

   Sensu Core users:

   ~~~ shell
   sudo /etc/init.d/sensu-server start
   sudo /etc/init.d/sensu-api start
   sudo /etc/init.d/sensu-client start
   ~~~

   Sensu Enterprise users:

   ~~~ shell
   sudo /etc/init.d/sensu-enterprise start
   sudo /etc/init.d/sensu-enterprise-dashboard start
   sudo /etc/init.d/sensu-client start
   ~~~

10. Verify that your installation is ready to use by querying the Sensu API
    using the `curl` utility (and piping the result to the [`jq` utility][13]):

    ~~~ shell
    curl -s http://127.0.0.1:4567/clients | jq .
    ~~~

    If the Sensu API returns a JSON array of Sensu clients similar to this:

    ~~~ shell
    $ curl -s http://127.0.0.1:4567/clients | jq .
    [
      {
        "timestamp": 1458625739,
        "version": "0.24.0",
        "socket": {
          "port": 3030,
          "bind": "127.0.0.1"
        },
        "subscriptions": [
          "dev"
        ],
        "environment": "development",
        "address": "127.0.0.1",
        "name": "client-01"
      }
    ]
    ~~~

    ...you have successfully installed and configured Sensu!

    If you you're using Sensu Enterprise, you should also be able to load the
    Sensu Enterprise Dashboard in your browser by visiting
    [http://hostname:3000](http://hostname:3000) (replacing `hostname` with the
    hostname or IP address of the system where the dashboard is installed).

    ![](../img/five-minute-dashboard-1.png)
    ![](../img/five-minute-dashboard-2.png)


[1]:  ../overview/architecture.html
[2]:  ../installation/overview.html
[3]:  ../installation/installation-strategies.html
[4]:  ../installation/installation-strategies.html#standalone
[5]:  http://releases.ubuntu.com/14.04/
[6]:  http://github.com/sensu/sensu-bash
[7]:  ../platforms/sensu-on-ubuntu-debian.html#install-sensu-core-repository
[8]:  https://www.youtube.com/watch?v=J2D1XF40-ok
[9]:  https://sensuapp.org/enterprise
[10]: /docs/0.24/files/simple-sensu-config.json
[11]: /docs/0.24/files/simple-client-config.json
[12]: /docs/0.24/files/simple-dashboard-config.json
[13]: https://stedolan.github.io/jq/
