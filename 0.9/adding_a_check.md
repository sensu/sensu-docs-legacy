---
layout: default
title: Adding a check
description: Adding a Sensu check
version: 0.9
---

# Adding a Sensu check

Now that we've installed a Sensu server and a client, let's create a
simple check so we can begin to see how the pieces fit together. We're
going to write a check to determine if `crond` is running. We'll be
using the `check-procs.rb` script from the
[sensu-community-plugins](https://github.com/sensu/sensu-community-plugins)
repo.

## Install check script

We need a script for sensu-client to execute in order to check the
condition we're interested in. The protocol for check scripts is the
same as Nagios plugins so you can re-use Nagios plugins as well.

We're going to use `check-procs.rb` from the
[sensu-community-plugins](https://github.com/sensu/sensu-community-plugins)
repo. 

If you have installed Sensu from the omnibus packages you can continue
to installing the `check-procs.rb` plugin. Otherwise we need to install
the `sensu-plugin` gem which has various helper classes used by many of
the community plugins:

    gem install sensu-plugin --no-rdoc --no-ri

Download and install `check-procs.rb`:

    wget -O /etc/sensu/plugins/check-procs.rb https://raw.github.com/sensu/sensu-community-plugins/master/plugins/processes/check-procs.rb
    chmod 755 /etc/sensu/plugins/check-procs.rb
    
## Create check definition JSON

Create this file on the Sensu server:

`/etc/sensu/conf.d/check_cron.json`:
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

## Subscriptions

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

## Testing

Finally, restart sensu on the client and server nodes.

After a few minutes we should see the following in the `/var/log/sensu/sensu-client.log` on the client:

    I, [2012-01-18T21:17:07.561000 #12984]  INFO -- : [subscribe] -- received check request -- cron_check {"message":"[subscribe] -- received check request -- cron_check","level":"info","timestamp":"2012-01-18T21:17:07.   %6N-0700"}

And on the server we should see the following in `/var/log/sensu/sensu-server.log`:

    I, [2012-01-18T21:18:07.559666 #30970]  INFO -- : [publisher] -- publishing check request -- cron_check -- webservers {"message":"[publisher] -- publishing check request -- cron_check -- webservers","level":"info","timestamp":"2012-01-18T21:18:07.   %6N-0700"}
    I, [2012-01-18T21:25:07.745012 #30970]  INFO -- : [result] -- received result -- sensu-client.domain.tld -- cron_check -- 0 -- CheckProcs OK: Found 1 matching processes; cmd /crond/
    
Next, let's see if we can raise an alert.

    /etc/init.d/crond stop

After about a minute we should see an alert on the sensu-dashboard: `http://<SERVER IP>:8080`, and in the sensu-server.log

Next: [Adding a handler](/{{ page.version }}/adding_a_handler.html)
