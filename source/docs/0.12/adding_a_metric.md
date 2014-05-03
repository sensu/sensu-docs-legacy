---
version: "0.12"
category: "Getting Started"
title: "Adding a metric"
---

# Adding a Sensu metric

As the Sensu check specification allows for structured data to be
outputted to `STDOUT`, Sensu can be used as a metric collection agent.

To add a metric we need to take a number of steps:

* Install the metrics check script on the client.
* Configure a metrics check definition on the server.
* Subscribe clients to the metric check

## Adding a metrics check script to the client

First we need to add a metrics check script to the client. We're going to use `load-metrics.rb` from the
[sensu-community-plugins](https://github.com/sensu/sensu-community-plugins) repo. A metrics check script is like a normal check script but returns a structured metric to `STDOUT` and always exits with an exit code of `0`.

Let's download and install `load-metrics.rb`:

~~~ bash
wget -O /etc/sensu/plugins/load-metrics.rb https://raw.github.com/sensu/sensu-community-plugins/master/plugins/system/load-metrics.rb
chmod 755 /etc/sensu/plugins/load-metrics.rb
~~~

Now let's run the metric from the command line and see the results:

~~~ bash
ruby load-metrics.rb
absinthe.local.load_avg.one 0.89  1365270842
absinthe.local.load_avg.five  1.01  1365270842
absinthe.local.load_avg.fifteen 1.06  1365270842
echo $?
0
~~~

We can see the check has outputted the 1/5/15 load average for our host
and a timestamp. We can also see that the metric check exited with a
status of `0`.

## Adding a metric check definition

Now we need to add a check definition for our metric on the server. A metric check looks like a normal check definition but with `"type":"metric"` added to the definition.

~~~ json
{
  "checks": {
    "load_metrics": {
      "type": "metric",
      "command": "load-metrics.rb",
      "subscribers": [
        "production"
      ],
      "interval": 10
    }
  }
}
~~~

## Subscribe the client to the check

We defined the check to run on nodes subscribed to the `production` channel.
Any client subscribed to this channel will execute this check.

Edit the `/etc/sensu/conf.d/client.json` file on the client and add the
`production` subscription (or wherever your `client` definition exists.  It may
be in `/etc/sensu/config.json` or in any snippet file in the
`/etc/sensu/conf.d/` directory)

~~~ json
{
  "client": {
    "name": "sensu-client.domain.tld",
    "address": "127.0.0.1",
    "subscriptions": [ "test", "production" ]
  }
}
~~~

## Testing the check

Finally, restart the Sensu server and client to activate the metric. 

You should shortly see the metric being executed on the client in the
`/var/log/sensu/sensu-client.log` log file.

And on the server we should see the result being returned in the
`/var/log/sensu/sensu-server.log` log file.

Next: [Adding a handler](adding_a_handler)
