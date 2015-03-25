---
version: 0.17
category: "Reference Docs"
title: "Checks"
next:
  url: "handlers"
  text: "Handlers"
---

# Checks

# Overview

This reference document provides information to help you:

- Understand what a Sensu check is
- How a Sensu check works
- Write a Sensu check definition
- Use built-in Sensu check definition attributes
- Use custom Sensu check definition attributes

# What are Sensu checks? {#what-are-sensu-checks}

Sensu checks allow you to monitor services or measure resources, they are executed on servers running the Sensu client. Checks are essentially commands (or scripts) that output data to `STDOUT` or `STDERR` and produce an exit status code to indicate a state. Common exit status codes used are `0` for `OK`, `1` for `WARNING`, `2` for `CRITICAL`, and `3` or greater to indicate `UNKNOWN` or `CUSTOM`. Sensu checks use the same specification as Nagios, therefore, Nagios check plugins may be used with Sensu.

## Example check plugin {#example-check-plugin}

The following is an example Sensu check plugin, a script located at `/etc/sensu/plugins/check-chef-client.rb`. This check plugin uses the running process list to determine if the Chef client process is running. This check plugin is written in Ruby, but Sensu plugins can be written in any language, e.g. Python, shell, etc.

~~~ ruby
# get the current list of processes
processes = `ps aux`

# determine if the chef-client process is running
running = processes.lines.detect do |process|
  process.include?('chef-client')
end

# return appropriate check output and exit status code
if running
  puts 'OK - Chef client process is running'
  exit 0
else
  puts 'WARNING - Chef client process is NOT running'
  exit 1
end
~~~

# Check definition

A Sensu check definition is a JSON configuration file describing a Sensu check. A definition declares how a Sensu check is executed:

- The command to run (e.g. script)
- How frequently it should be executed (interval)
- Where it should be executed (which machines)

## Example check definition {#example-check-definition}

The following is an example Sensu check definition, a JSON configuration file located at `/etc/sensu/conf.d/check_chef_client.json`. This check definition uses the [example check plugin](#example-check-plugin) above, to determine if the Chef client process is running. The check is named `chef_client` and it runs `/etc/sensu/plugins/check-chef-client.rb` on Sensu clients with the `production` subscription, every `60` seconds (interval).

~~~ json
{
  "checks": {
    "chef_client": {
      "command": "/etc/sensu/plugins/check-chef-client.rb",
      "subscribers": [
        "production"
      ],
      "interval": 60
    }
  }
}
~~~

# Anatomy of a check definition

### Name

Each check definition has a unique check name, used for the definition key.

- A unique string used to name/identify the check
- Cannot contain special characters or spaces
- Validated with `/^[\w\.-]+$/`
- e.g. `"chef_client": {}`

### Definition attributes

Attribute | Description
---------:|:-----------
*type* **Optional** **String** | The check type. Use either **standard** or **metric**. Setting **type** to **metric** will cause OK (exit 0) check results to create events. `"type": "metric"`
*command* **REQUIRED** **String** | Not required if **extension** is configured. The check command to be executed. `"command": "/etc/sensu/plugins/check-chef-client.rb"`
*extension* **REQUIRED** **String** | Not required if **command** is configured. This is an _advanced feature_ and is not commonly used. The name of a Sensu check extension to run instead of a command. `"extension": "system_profile"`
*standalone* **OPTIONAL** **Boolean** | If the check is scheduled by the local Sensu client instead of the Sensu server.
*subscribers* **REQUIRED** **Array** | Not required if **standalone** is set to **true**. An array of Sensu client subscriptions that check requests will be sent to. The array cannot be empty. Each array item must be a string. `"subscribers": ["production"]`
*publish* **OPTIONAL** **Boolean** | If check requests are published for the check. `"publish": false`
*interval* **REQUIRED** **Integer** | Not required if **publish** is set to **false**. The frequency in seconds to execute the check. `"interval": 60`
*timeout* **OPTIONAL** **Integer** | The check execution duration timeout in seconds (hard stop). `"timeout": 30`
*handle* **OPTIONAL** **Boolean** | If events created by the check should be handled. `"handle": "false"`
*handler* **OPTIONAL** **String** | The Sensu event handler to use for events created by the check. `"handler": "pagerduty"`
*handlers* **OPTIONAL** **Array** | An array of Sensu event handlers (names) to use for events created by the check. Each array item must be a string. `"handlers": ["pagerduty", "email"]`
*low_flap_threshold* **OPTIONAL** **Integer** | The flap detection low threshold (% state change). Sensu uses the same [flap detection algorithm as Nagios](http://nagios.sourceforge.net/docs/3_0/flapping.html). `"low_flap_threshold": 20`
*high_flap_threshold* **OPTIONAL** **Integer** | The flap detection high threshold (% state change). Sensu uses the same [flap detection algorithm as Nagios](http://nagios.sourceforge.net/docs/3_0/flapping.html). **low_flap_threshold** must be configured for this attribute to have any effect. `"high_flap_threshold": 60`
*source* **OPTIONAL** **String** | A string to add context to the check result. `"source": "switch-dc-01"`
*subdue* **OPTIONAL** **Hash** | A set of attributes that define when a check is subdued. See [Subdue attributes](#check-subdue-attributes) for more information. `"subdue": {}`

#### Subdue attributes {#check-subdue-attributes}

Attribute | Description
---------:|:-----------
*at* **OPTIONAL** **String** | Where the check is subdued. Use either **handler** or **publisher**. `"at": "handler"`
*days* **OPTIONAL** **Array** | Which days of the week the check is subdued. An array of days of the week. Each array item must be a string and a valid day of the week. `"days": ["monday", "wednesday"]`
*begin* **REQUIRED** **String** | Beginning of the time window when the check is subdued. Parsed by Ruby's **Time.parse()** method. May include a time zone. `"begin": "5PM PST"`
*end* **REQUIRED** **String** | End of the time window when the check is subdued. Parsed by Ruby's **Time.parse()** method. May include a time zone. `"end": "9AM PST"`
*exceptions* **OPTIONAL** **Array** | Subdue time window (begin, end) exceptions. Takes an array of hashes, containing valid **begin** and **end** times. `"exceptions": [{"begin": "8PM PST", "end": "10PM PST"}]`

