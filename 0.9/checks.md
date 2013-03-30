---
layout: default
title: Checks
description: Sensu checks
version: 0.9
---

# Sensu checks

## What are checks?
Checks allow you to monitor services or measure resources, they are executed on servers running the Sensu client. Checks are essentially commands (or scripts) that output data to STDOUT/ERR and produce an exit status code to indicate a state. Common exit status codes used are 0 for OK, 1 for WARNING, 2 for CRITICAL, and 3 or greater to indicate UNKNOWN or CUSTOM. As you may have realized, the Sensu check specification is compatible with Nagios, so you can use Nagios plugins with Sensu.

#### Example

##### Check plugin (/etc/sensu/plugins/check-chef-client.rb)

{% highlight ruby %}
procs = `ps aux`
running = false
procs.each_line do |proc|
  running = true if proc.include?('chef-client')
end
if running
  puts 'OK - Chef client daemon is running'
  exit 0
else
  puts 'WARNING - Chef client daemon is NOT running'
  exit 1
end
{% endhighlight %}

##### Check definition (configuration)

{% highlight json %}
{
  "checks": {
    "chef_client": {
      "command": "check-chef-client.rb",
      "subscribers": [
        "production"
      ],
      "interval": 60
    }
  }
}
{% endhighlight %}

##### Explanation of definition
* `chef_client`: A unique check name
* `command`: The command that will be executed
* `subscribers`: Which subscriptions must execute this check (see [client info](Client Info))
* `interval`: How frequently (in seconds) the check will be executed

### How check results produce events
By default, only non-zero (exit status > 0) check results produce an event, causing the creation of [event data](Event Data) which is passed to one or more [handlers](Handlers). Sensu concerns itself with "the bad", as this is what requires action.

### Handler routing
By default, events will be passed to the `default` [handler](Handlers), unless the check definition says otherwise. You can specify a specific handler in the check definition by using `"handler": "foo"` or specify one or more handlers with `"handlers": ["foo", "bar"]`.

#### Example

##### Check definition (configuration)

{% highlight json %}
{
  "checks": {
    "chef_client": {
      "command": "check-chef-client.rb",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "handlers": [
        "pagerduty",
        "irc"
      ]
    }
  }
}
{% endhighlight %}

Events produce by this check will be handled by the `pagerduty` and `irc` handlers.

### Metric checks
As the Sensu check specification allows for structured data to be outputted to STDOUT, Sensu can be used as a metric collection agent. To allow check results with a exit status of 0 to produce an event, add `"type": "metric"` to the check definition.

#### Example

##### Check plugin (/etc/sensu/plugins/cpu-usage-metrics.sh)

{% highlight bash %}
#!/bin/bash

SCHEME=`hostname`

usage()
{
  cat <<EOF
usage: $0 options

This plugin produces CPU usage (%) using /proc/stat

OPTIONS:
   -h      Show this message
   -s      Metric naming scheme, text to prepend to cpu.usage
EOF
}

while getopts "hs:" OPTION
  do
    case $OPTION in
      h)
        usage
        exit 1
        ;;
      s)
        SCHEME="$OPTARG"
        ;;
      ?)
        usage
        exit 1
        ;;
    esac
done

get_idle_total()
{
  CPU=(`cat /proc/stat | grep '^cpu '`)
  unset CPU[0]
  IDLE=${CPU[4]}
  TOTAL=0
  for VALUE in "${CPU[@]}"; do
    let "TOTAL=$TOTAL+$VALUE"
  done
}

get_idle_total
PREV_TOTAL="$TOTAL"
PREV_IDLE="$IDLE"

sleep 1

get_idle_total

let "DIFF_IDLE=$IDLE-$PREV_IDLE"
let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"

echo "$SCHEME.cpu.usage $DIFF_USAGE `date +%s`"
{% endhighlight %}

##### Check plugin produces
`foo.cpu.usage 4 1350486269`

##### Check definition (configuration)

{% highlight json %}
{
  "checks": {
    "cpu_usage_metrics": {
      "type": "metric",
      "command": "cpu-usage-metrics.sh",
      "subscribers": [
        "production"
      ],
      "interval": 10
    }
  }
}
{% endhighlight %}

### Standalone checks
Standalone checks are scheduled by the Sensu clients themselves, instead of having a Sensu server publish a check request to specific subscriptions. Standalone checks are scheduled and executed on a any client they are defined on. Add `"standalone": true` to a check definition to make it standalone, replacing `"subscribers"`.

#### Example

##### Check definition (configuration)

{% highlight json %}
{
  "checks": {
    "cpu_usage_metrics": {
      "type": "metric",
      "command": "cpu-usage-metrics.sh",
      "standalone": true,
      "interval": 10
    }
  }
}
{% endhighlight %}

### Check command token substitution
At check execution time, the Sensu client will inspect the check command for substitution tokens, a pattern containing a client attribute key, to be substituted by its value. See refer to [client info](Client Info).

#### Example

##### Check definition (configuration)

{% highlight json %}
{
  "checks": {
    "chef_client": {
      "command": "check-mysql-replication.rb --user :::mysql.user::: --password :::mysql.password:::",
      "subscribers": [
        "mysql"
      ],
      "interval": 60
    }
  }
}
{% endhighlight %}

### Custom check definition key-values
Custom key-values can be added to a check definition, which will be included in [event data](Event Data), enabling [handler](Handlers) creativity. 

##### Common custom check definitions
* `occurrences`: Number of event occurrences before the handler should take action
* `refresh`: Number of seconds handlers should wait before taking second action. Relies on `sensu-plugin`.

#### Example

##### Check definition (configuration)

{% highlight json %}
{
  "checks": {
    "chef_client": {
      "command": "check-chef-client.rb",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "occurrences": 2,
      "refresh": 1800
    }
  }
}
{% endhighlight %}

### Flap detection
Sensu supports check state flap detection, adding a flag `"flapping": true` to event data when a check changes state "too frequently", determined by thresholds. An event marked as flapping will not resolve until it is no longer flapping. The implementation is very similar to [Nagios flap detection](http://nagios.sourceforge.net/docs/3_0/flapping.html).

#### Example

##### Check definition (configuration)

{% highlight json %}
{
  "checks": {
    "chef_client": {
      "command": "check-chef-client.rb",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "low_flap_threshold": "5",
      "high_flap_threshold": "25"
    }
  }
}
{% endhighlight %}

