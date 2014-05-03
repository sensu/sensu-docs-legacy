---
version: "0.11"
category: "Configuration"
title: "Checks"
---

# Sensu checks

## What are checks?

Checks allow you to monitor services or measure resources, they are
executed on servers running the Sensu client.  Checks are essentially
commands (or scripts) that output data to `STDOUT` or `STDERR` and
produce an exit status code to indicate a state. Common exit status
codes used are `0` for `OK`, `1` for `WARNING`, `2` for `CRITICAL`, and
`3` or greater to indicate `UNKNOWN` or `CUSTOM`. As you may have
realized, the Sensu check specification is compatible with Nagios, so
you can use Nagios plugins with Sensu.

#### Example

##### Check plugin (/etc/sensu/plugins/check-chef-client.rb)

~~~ ruby
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
~~~

##### Check definition (configuration)

~~~ json
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
~~~

##### Explanation of definition
* `chef_client`: A unique check name
* `command`: The command that will be executed
* `subscribers`: Which subscriptions must execute this check (see
  [client info](clients))
* `interval`: How frequently (in seconds) the check will be executed

### How check results produce events

By default, only non-zero (exit status > 0) check results produce an
event, causing the creation of [event data](events) which is passed to one or more [handlers](handlers). Sensu concerns itself with "the bad", as
this is what requires action.

### Handler routing

By default, events will be passed to the `default` [handler](handlers), unless the check definition says
otherwise. You can specify a specific handler in the check definition by
using `"handler": "foo"` or specify one or more handlers with
`"handlers": ["foo", "bar"]`.

#### Example

##### Check definition (configuration)

~~~ json
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
~~~

Events produce by this check will be handled by the `pagerduty` and `irc` handlers.

### Disabling check handling

Handling can be disabled for specific checks, so that handlers are not triggered. You can configure this be setting `"handle": false` on the check definition.

#### Example

##### Check definition (configuration)

~~~ json
{
  "checks": {
    "chef_client": {
      "command": "check-chef-client.rb",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "handle": false
    }
  }
}
~~~

Events produced by this check will never be handled.

### Subduing Check Handling

In addition to the ability to fully disable the handling of certain checks, Sensu
supports 'subduing' checks so that they are not handled during certain hours
of the day.  This is done by configuring the `"begin"` and `"end"` times
for the check's `"subdue"` attribute.

The `"begin"` and `"end"` times are parsed with Ruby's generous `Time.parse`,
which is flexible enough to handle different zones and format.

#### Example

##### Check definition (configuration)

~~~ json
{
  "checks": {
    "noisy_noncritical_check": {
      "command": "queues_are_hard_to_monitor.rb",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "subdue": {
        "begin": "5PM PST",
        "end": "9AM PST"
      }
    }
  }
}
~~~

Events produced by this check will not be handled between 5PM and 9AM PST.

### Metric checks

As the Sensu check specification allows for structured data to be
outputted to `STDOUT`, Sensu can be used as a metric collection agent.
To allow check results with a exit status of 0 to produce an event, add
`"type": "metric"` to the check definition.

#### Example

##### Check plugin (/etc/sensu/plugins/cpu-usage-metrics.sh)

~~~ bash
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
~~~

##### Check plugin produces

    foo.cpu.usage 4 1350486269

##### Check definition (configuration)

~~~ json
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
~~~

### Standalone checks

Standalone checks are scheduled by the Sensu clients themselves, instead
of having a Sensu server publish a check request to specific
subscriptions. Standalone checks are scheduled and executed on a any
client they are defined on. Add `"standalone": true` to a check
definition to make it standalone, replacing `"subscribers"`.

#### Example

##### Check definition (configuration)

~~~ json
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
~~~

### Manually triggered checks

In addition to server-scheduled and client-scheduled (standalone) checks, checks can be
defined that are not scheduled for regualar execution.  These pre-defined checks can be
triggered through the API. Add `"publish": false` to a check definition to disable the
interval-based scheduling. The `interval` field may still be required to pass validation.

#### Example

##### Check definition (configuration)

~~~ json
{
  "checks": {
    "my_predefined_check": {
      "type": "metric",
      "command": "cpu-usage-metrics.sh",
      "publish": false,
      "interval": 9999
    }
  }
}
~~~

##### API Call

~~~ bash
curl -XPOST http://api.sensu.example.com:4567/check/request -d '{"subscribers": ["appservers"], "check":"my_predefined_check"}'
~~~

### Check command token substitution

At check execution time, the Sensu client will inspect the check command
for substitution tokens, a pattern containing a client attribute key, to
be substituted by its value. Refer to [client info](clients). 
You can also specify a default value if the key does not exist `:::foo.bar|default:::`

#### Example

##### Check definition (configuration)

~~~ json
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
~~~

### Custom check definition key-values

Custom key-values can be added to a check definition, which will be
included in [event data](events), enabling
[handler](handlers)
creativity.

##### Common custom check definitions

* `occurrences`: Number of event occurrences before the handler should take action
* `refresh`: Number of seconds handlers should wait before taking second action. Relies on `sensu-plugin`.

#### Example

##### Check definition (configuration)

~~~ json
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
~~~

### Flap detection

Sensu supports check state flap detection, adding a flag `"flapping":
true` to event data when a check changes state "too frequently",
determined by thresholds. An event marked as flapping will not resolve
until it is no longer flapping. The implementation is very similar to
[Nagios flap detection](http://nagios.sourceforge.net/docs/3_0/flapping.html).

#### Example

##### Check definition (configuration)

~~~ json
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
~~~

