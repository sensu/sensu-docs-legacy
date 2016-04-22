---
version: 0.23
category: "Overview"
title: "Sensu 0.23.x changelog"
info:
warning:
danger:
---

# Sensu Core version 0.23.x changelog

## 0.23.0 Release Notes {#v0-23-0}

Source: [GitHub.com](https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0230---2016-04-04)

**April 4, 2016** &mdash; Sensu Core version 0.23.0 has been released and is
available for immediate download. Please note the following improvements:

- **NEW:** dropped support for Rubies < 2.0.0, as they have long been EOL
  and have proven to be a hindrance and security risk.

- **NEW:** the Sensu 0.23 packages use [Ruby 2.3][1].

- **NEW:** native support for [Redis Sentinel][2]. Sensu services can now be
  configured to query one or more instances of Redis Sentinel for a Redis
  master. This feature eliminates the last need for load balancing middleware
  (e.g. HAProxy) in highly available Sensu configurations. To configure Sensu
  services to use Redis Sentinel, hosts and ports of one or more Sentinel
  instances must be provided.

  Example Redis Sentinel configuration:

  ~~~ json
  "sentinels": [
    {
      "host": "10.0.1.23",
      "port": 26479
    }
  ]
  ~~~

  See the [Redis configuration documentation][3] for more information.

- **NEW:** Added a CLI option/argument to cause the Sensu service to print
  (output to STDOUT) its compiled configuration settings and exit. The CLI
  option is `--print_config` or `-P`.

  See the [Sensu CLI arguments][4] documentation for more information.

- **NEW:** Added token substitution to filter eval attributes, providing
  access to event data.

  Example filter eval token:

  ~~~ json
  {
    "filters": {
      "example_filter": {
        "attributes": {
          "occurrences": "eval: value > :::check.occurrences:::"          
        }
      }
    }
  }
  ~~~

- **NEW:** native installer packages are now available for IBM AIX systems
  (sensu-client only).

- **NEW:** The pure Ruby EventMachine reactor is used when running on AIX.

- **IMPROVEMENT:** The Sensu Transport API has changed. Transports are now a
  deferrable, they must call `succeed()` once they have fully initialized. Sensu
  now waits for its transport to fully initialize before taking other actions.

- **IMPROVEMENT:** performance improvements. Dropped MultiJson in favour of
  Sensu JSON, a lighter weight JSON parser abstraction that supports platform
  specific parsers for Sensu Core and Enterprise. The Oj JSON parser is
  once again used for Sensu Core. Used [fast-ruby][5] and benchmarks as a guide
  to further changes.

- **IMPROVEMENT:** Using EventMachine 1.2.0, which brings several changes and
  improvements ([changelog][6]).

[1]:  https://www.ruby-lang.org/en/news/2015/12/25/ruby-2-3-0-released/
[2]:  http://redis.io/topics/sentinel
[3]:  redis#redis-high-availability-configuration
[4]:  configuration#sensu-command-line-interfaces-and-arguments
[5]:  https://github.com/JuanitoFatas/fast-ruby
[6]:  https://github.com/eventmachine/eventmachine/blob/master/CHANGELOG.md#1201-march-15-2016
