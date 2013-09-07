---
layout: default
title: Adding a standalone check
description: Adding a Sensu standalone check
version: '0.10'
---

# Adding a Sensu standalone check

Standalone checks are defined and executed on the client and require no
server configuration. 

To add a standalone check we need to take a number of steps:

* Install the check script or command on the client.
* Define the check on the Sensu client.

## Install check script on the client

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

## Adding a check definition on the client

Standalone checks are scheduled by the Sensu clients themselves, instead
of having a Sensu server publish a check request to specific
subscriptions. Standalone checks are scheduled and executed on a any
client they are defined on. Add `"standalone": true` to a check
definition to make it standalone, replacing `"subscribers"`.

{% highlight json %}
    {
      "checks": {
        "cron_check": {
          "handlers": ["default"],
          "command": "/etc/sensu/plugins/check-procs.rb -p crond -C 1 ",
          "interval": 60,
          "standalone": true,
        }
      }
    }
{% endhighlight %}

## Testing the check

Finally, restart Sensu on the client.

After a few minutes we should see the check executed in the
`/var/log/sensu/sensu-client.log` log file on the client.

Next: [Adding a metric](/{{ page.version }}/adding_a_metric.html)
