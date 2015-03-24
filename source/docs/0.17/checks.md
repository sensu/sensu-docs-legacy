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

  - `type`
    - **Optional**
    - The check type
    - A string, either `standard` or `metric`
    - Setting `type` to `metric` will cause OK (exit 0) check results to create events
    - e.g. `"type": "metric"`

  - `command`
    - **Required** unless `extension` is configured
    - The check command to be executed
    - e.g. `"command": "/etc/sensu/plugins/check-chef-client.rb"`

  - `extension`
    - **Required** unless `command` is configured
    - This is an _advanced feature_ and is not commonly used
    - The name of a Sensu check extension to run instead of a command
    - A string to identify a Sensu check extension by name
    - e.g. `"extension": "system_profile"`

  - `standalone`
    - **Optional**
    - If the check is scheduled by the local Sensu client instead of the Sensu server
    - Boolean (true or false)

  - `subscribers`
    - **Required** unless `standalone` is `true`
    - An array of Sensu client subscriptions that check requests will be sent to
    - The array cannot be empty
    - Each array item must be a string
    - e.g. `"subscribers": ["production"]`

  - `publish`
    - **Optional**
    - If check requests are published for the check
    - Boolean (true or false)
    - e.g. `"publish": false`

  - `interval`
    - **Required** unless `publish` is `false`
    - The frequency in seconds to execute the check
    - An integer
    - e.g. `"interval": 60`

  - `timeout`
    - **Optional**
    - The check execution duration timeout in seconds (hard stop)
    - An integer
    - e.g. `"timeout": 30`

  - `handle`
    - **Optional**
    - If events created by the check should be handled
    - Boolean (true or false)
    - e.g. `"handle": "false"`

  - `handler`
    - **Optional**
    - The Sensu event handler to use for events created by the check
    - A string to identify the event handler by name
    - e.g. `"handler": "pagerduty"`

  - `handlers`
    - **Optional**
    - An array of Sensu event handlers (names) to use for events created by the check
    - Each array item must be a string
    - e.g. `"handlers": ["pagerduty", "email"]`

  - `low_flap_threshold`
    - **Optional**
    - The flap detection low threshold (% state change)
    - An integer
    - Sensu uses the same [flap detection algorithm as Nagios](http://nagios.sourceforge.net/docs/3_0/flapping.html)
    - e.g. `"low_flap_threshold": 20`

  - `high_flap_threshold`
    - **Optional**
    - The flap detection high threshold (% state change)
    - An integer
    - Sensu uses the same [flap detection algorithm as Nagios](http://nagios.sourceforge.net/docs/3_0/flapping.html)
    - `low_flap_threshold` must be configured for this attribute to have any effect
    - e.g. `"high_flap_threshold": 60`

  - `source`
    - **Optional**
    - A string to add context to the check result
    - e.g. `"source": "switch-dc-01"`

  - `subdue`
    - **Optional**
    - A set of attributes that define when a check is subdued
    - A hash
    - e.g. `"subdue": {}`
    - Subdue attributes:

      - `at`
        - Where the check is subdued
        - A string, either `handler` or `publisher`
        - e.g. `"at": "handler"`

      - `days`
        - Which days of the week the check is subdued
        - An array of days of the week
        - Each array item must be a string and a valid day of the week
        - e.g. `"days": ["monday", "wednesday"]`

      - `begin`
        - Beginning of the time window when the check is subdued
        - A string containing a time
        - Parsed by Ruby’s Time.parse()
        - May include a time zone
        - e.g. `"begin": "5PM PST"`

      - `end`
        - End of the time window when the check is subdued
        - A string containing a time
        - Parsed by Ruby’s Time.parse()
        - May include a time zone
        - e.g. `"end": "9AM PST"`

      - `exceptions`
        - Subdue time window (begin, end) exceptions
        - An array of hashes, containing valid `begin` and `end` times
        - e.g. `"exceptions": [{"begin": "8PM PST", "end": "10PM PST"}]`
