---
layout: default
title: Adding a check
description: Adding a Sensu check
version: '0.10'
---

# Adding a Sensu check

Now that we've installed a Sensu server and a client, let's create a
simple check so we can begin to see how the pieces fit together. We're
going to write a check to determine if `crond` is running. We'll be
using the `check-procs.rb` script from the
[sensu-community-plugins](https://github.com/sensu/sensu-community-plugins)
repo.

To add a check we need to take a number of steps:

* Install the check script on the client
* Create the check definition on the Sensu server
* Subscribe the Sensu client to the check.

## Install the check script on the client

We need a script for the Sensu client to execute in order to check the
condition we're interested in. The protocol for check scripts is the
same as Nagios plugins so you can re-use Nagios plugins as well.

We're going to use `check-procs.rb` from the
[sensu-community-plugins](https://github.com/sensu/sensu-community-plugins)
repo. 

If you have installed Sensu from the omnibus packages you can continue
to installing the `check-procs.rb` plugin. Otherwise we need to install
the `sensu-plugin` gem which has various helper classes used by many of
the community plugins:

{% highlight bash %}
    gem install sensu-plugin --no-rdoc --no-ri
{% endhighlight %}

Download and install `check-procs.rb`:

{% highlight bash %}
    wget -O /etc/sensu/plugins/check-procs.rb https://raw.github.com/sensu/sensu-community-plugins/master/plugins/processes/check-procs.rb
    chmod 755 /etc/sensu/plugins/check-procs.rb
{% endhighlight %}
    
## Create the check definition on the Sensu server

Create this file on the Sensu server:
`/etc/sensu/conf.d/check_cron.json`.

{% highlight json %}
    {
      "checks": {
        "cron_check": {
          "handlers": ["default"],
          "command": "/etc/sensu/plugins/check-procs.rb -p crond -C 1 ",
          "interval": 60,
          "subscribers": [ "webservers" ]
        }
      }
    }
{% endhighlight %}

## Subscribe the client to the check

We defined the check to run on nodes subscribed to the `webservers`
channel. Any client subscribed to this channel will execute this check.

Edit the `/etc/sensu/conf.d/client.json` file on the client and add the
`webservers` subscription (or wherever your `client` definition exists.
It may be in `/etc/sensu/config.json` or in any snippet file in the
`/etc/sensu/conf.d/` directory)

{% highlight json %}
    {
      "client": {
        "name": "sensu-client.domain.tld",
        "address": "127.0.0.1",
        "subscriptions": [ "test", "webservers" ]
      }
    }
{% endhighlight %}

## Testing the check

Finally, restart Sensu on the client and server nodes.

After a few minutes we should see the following in the `/var/log/sensu/sensu-client.log` on the client:

    I, [2012-01-18T21:17:07.561000 #12984]  INFO -- : [subscribe] -- received check request -- cron_check {"message":"[subscribe] -- received check request -- cron_check","level":"info","timestamp":"2012-01-18T21:17:07.   %6N-0700"}

And on the server we should see the following in `/var/log/sensu/sensu-server.log`:

    I, [2012-01-18T21:18:07.559666 #30970]  INFO -- : [publisher] -- publishing check request -- cron_check -- webservers {"message":"[publisher] -- publishing check request -- cron_check -- webservers","level":"info","timestamp":"2012-01-18T21:18:07.   %6N-0700"}
    I, [2012-01-18T21:25:07.745012 #30970]  INFO -- : [result] -- received result -- sensu-client.domain.tld -- cron_check -- 0 -- CheckProcs OK: Found 1 matching processes; cmd /crond/
    
Next, let's see if we can raise an alert.

    /etc/init.d/crond stop

After about a minute we should see an alert on the sensu-dashboard:
`http://<SERVER IP>:8080`, and in the `sensu-server.log`.

Next: [Adding a standalone check](/{{ page.version }}/adding_a_standalone_check.html)

# Adding a Sensu check in Windows

Now that we've installed a Sensu server and a Windows Sensu client, let's create a
simple check so we can begin to see how the pieces fit together. We're
going to write a check to determine if our volumes are filling up. We'll be
using the `check-disk-windows.rb` script from the
[sensu-community-plugins](https://github.com/sensu/sensu-community-plugins)
repo.

To add a check we need to take a number of steps:

* Install the check script on the client
* Create the check definition on the Sensu server
* Subscribe the Sensu client to the check.

## Install the check script on the Windows client

We need a script for the Sensu client to execute in order to check the
condition we're interested in. The protocol for check scripts is the
same as Nagios plugins so you can re-use Nagios plugins as well.

We're going to use `check-disk-windows.rb` from the
[sensu-community-plugins](https://github.com/sensu/sensu-community-plugins)
repo. 

You must have installed Sensu from the MSI package before continuing 
to the install of the `check-disk-windows.rb` plugin.

We need to install the `sensu-plugin` gem which has various helper classes used by many of
the community plugins:

{% highlight bash %}
    C:> \opt\sensu\embedded\bin\gem install sensu-plugin --no-rdoc --no-ri
{% endhighlight %}

Our check-disk-windows.rb plugin also requires the ActiveSupport 4.0 gem or above.

{% highlight bash %}
    C:> \opt\sensu\embedded\bin\gem install activesupport --no-rdoc --no-ri
{% endhighlight %}

Download `check-disk-windows.rb` from the [sensu-community-plugins](https://raw.github.com/sensu/sensu-community-plugins/master/plugins/windows/check-disk-windows.rb)
repo to your Windows client.

Create the plugins directory and copy the downloaded check-disk-windows.rb to the new directory.

{% highlight bash %}
    C:\opt\sensu\plugins\check-disk-windows.rb
{% endhighlight %}

## Create the check definition on the Sensu server

Create this file on the Sensu server:
`/etc/sensu/conf.d/check_disk-windows.json`.

{% highlight json %}
    {
      "checks": {
        "check-disk-windows": {
          "handlers": ["default"],
          "command": "/opt/sensu/embedded/bin/ruby.exe /opt/sensu/plugins/check-disk-windows.rb",
          "interval": 60,
          "subscribers": [ "windows" ]
        }
      }
    }
{% endhighlight %}

## Subscribe the client to the check

We defined the check to run on nodes subscribed to the `windows`
channel. Any client subscribed to this channel will execute this check.

Edit the `/opt/sensu/conf.d/client.json` file on the Windows client and add the
`windows` subscription.  This file may already exist if you followed the Windows
install directions on the [Installing Sensu](/{{ page.version }}/installing_sensu.html) page.
Simply add the 'windows' subscription as noted below.

{% highlight json %}
    {
      "client": {
        "name": "CLIENT_NODE_NAME",
        "address": "CLIENT_IP_ADDRESS",
        "subscriptions": [
          "windows"  
        ]
      }
    }
{% endhighlight %}

## Testing the check

Finally, restart Sensu on the Windows client and Sensu server nodes.

After a few minutes we should see the following in the `/opt/sensu/sensu-client.log` on the client:

    {"timestamp":"2013-09-04T15:34:13.180419-0500","level":"info","message":"received check request","check":{"name":"check-disk-windows","issued":1378326853,"command":"/opt/sensu/plugins/check-disk-windows.rb"}}

And on the server we should see the following in `/var/log/sensu/sensu-server.log`:

    {"timestamp":"2013-09-04T11:39:12.442472-0500","level":"info","message":"publishing check request","payload":{"name":"check-disk-windows","issued":1378312752,"command":"/opt/sensu/plugins/check-disk-windows.rb"},"subscribers":["windows"]}
    
Next, let's see if we can raise an alert by lowering the default WARNING
threshhold to 10% (or to a level less than the free space available on
your volumes)

Edit this file on the Sensu server again and add the -w parameter to the command:
`/etc/sensu/conf.d/check_disk-windows.json`.

{% highlight json %}
    {
      "checks": {
        "check-disk-windows": {
          "handlers": ["default"],
          "command": "/opt/sensu/embedded/bin/ruby.exe /opt/sensu/plugins/check-disk-windows.rb -w 10",
          "interval": 60,
          "subscribers": [ "windows" ]
        }
      }
    }
{% endhighlight %}

Restart the sensu-server service.

After about a minute we should see an alert on the sensu-dashboard:
`http://<SERVER IP>:8080`, and in the `sensu-server.log`.

