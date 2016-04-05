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

- **NEW:** Dropped support for Rubies < 2.0.0, as they have long been EOL
  and have proven to be a hindrance and security risk.

- **NEW:** The Sensu Transport API changed. Transports are now a
  deferrable, they must call succeed() once they have fully initialized.
  Sensu now waits for its transport to fully initialize before taking
  other actions.

- **NEW:** Redis Sentinel support for HA Redis. Sensu services can now be
  configured to query one or more instances of Redis Sentinel for a Redis
  master. This feature eliminates the last need for HAProxy in highly
  available Sensu configurations. To configure Sensu services to use Redis
  Sentinel, hosts and ports of one or more Sentinel instances must be
  provided, e.g. "sentinels": [{"host": "10.0.1.23", "port": 26479}].

- **NEW:** Added a CLI option/argument to cause the Sensu service to print
  (output to STDOUT) its compiled configuration settings and exit. The CLI
  option is --print_config or -P.

- **NEW:** Added token substitution to filter eval attributes, providing
  access to event data, e.g. "occurrences": "eval: value == :::check.occurrences:::".

- **NEW:** The pure Ruby EventMachine reactor is used when running on AIX.

- **NEW:** The Sensu 0.23 packages use Ruby 2.3.

- **NEW:** Performance improvements. Dropped MultiJson in favour of Sensu
  JSON, a lighter weight JSON parser abstraction that supports platform
  specific parsers for Sensu Core and Enterprise. The Oj JSON parser is
  once again used for Sensu Core. Used
  https://github.com/JuanitoFatas/fast-ruby and benchmarks as a guide to
  further changes.

- **NEW:** Using EventMachine 1.2.0, which brings several changes and
  improvements:
  https://github.com/eventmachine/eventmachine/blob/master/CHANGELOG.md#1201-march-15-2016
