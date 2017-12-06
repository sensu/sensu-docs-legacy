---
title: "0.23 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 0.23.x"
version: 0.23
weight: 5
---

# Changelog

_NOTE:	Although we endeavor to keep this combined changelog up-to-date,
	the [official Sensu Core changelog][0] may describe changes not
	yet documented here._

## Releases

- [Sensu Enterprise version 1.12.3](#enterprise-v1-12-4)
- [Sensu Core version 0.23.3](#core-v0-23-3)
- [Sensu Enterprise version 1.12.3](#enterprise-v1-12-3)
- [Sensu Enterprise version 1.12.2](#enterprise-v1-12-2)
- [Sensu Enterprise version 1.12.1](#enterprise-v1-12-1)
- [Sensu Enterprise version 1.12.0](#enterprise-v1-12-0)
- [Sensu Core version 0.23.2](#core-v0-23-2)
- [Sensu Core version 0.23.1](#core-v0-23-1)
- [Sensu Core version 0.23.0](#core-v0-23-0)

## Enterprise 1.12.4 Release Notes {#enterprise-v1-12-4}

**May 27, 2016** &mdash; Sensu Enterprise version 1.12.4 has been released and
is available for immediate download. Please note the following improvements:

- **IMPROVEMENT:** Fixed `EMBEDDED_RUBY` ENV variable by exporting it.

- **IMPROVEMENT:** Built on [Sensu Core 0.23.3][11].

## Core 0.23.3 Release Notes {#core-v0-23-3}

Source: [GitHub.com](https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0233---2016-05-26)

**May 26, 2016** &mdash; Sensu Core version 0.23.3 has been released and is
available for immediate download. Please note the following improvements:

- **IMPROVEMENT:** Fixed child process write/read deadlocks when writing to
  STDIN or reading from STDOUT/STDERR, when the data size exceeds the pipe
  buffers.

- **IMPROVEMENT:** Fixed child process spawn timeout deadlock, now using stdlib
  Timeout.

## Enterprise 1.12.3 Release Notes {#enterprise-v1-12-3}

**May 20, 2016** &mdash; Sensu Enterprise version 1.12.3 has been released and
is available for immediate download. Please note the following improvements:

- **IMPROVEMENT:** Set Java IO tmpdir to nix `$TMPDIR`.

## Enterprise 1.12.2 Release Notes {#enterprise-v1-12-2}

**May 16, 2016** &mdash; Sensu Enterprise version 1.12.2 has been released and
is available for immediate download. Please note the following improvements:

- **IMPROVEMENT:** Fixed Slack integration icon URL, non-transparent png on S3.

## Enterprise 1.12.1 Release Notes {#enterprise-v1-12-1}

**April 28, 2016** &mdash; Sensu Enterprise version 1.12.1 has been released and
is available for immediate download. Please note the following improvements:

- **IMPROVEMENT:** Fixed Puppet integration PuppetDB API error response
  handling.

## Enterprise 1.12.0 Release Notes {#enterprise-v1-12-0}

**April 26, 2016** &mdash; Sensu Enterprise version 1.12.0 has been released and
is available for immediate download. Please note the following improvements:

- **NEW:** [ServiceNow integration][8]. Manage ServiceNow CMDB configuration
  items, and create/update/resolve ServiceNow incidents.

- **NEW:** [Puppet integration][9]. Remove Sensu clients from the client
  registry when there is not an associated Puppet node or the node has been
  deactivated (e.g. purged).

- **NEW:** Built on [Sensu Core 0.23.2][10].

- **IMPROVEMENT:** Fixed a Tessen agent thread leak on SIGHUP reload.

- **IMPROVEMENT:** Fixed HTTP client thread pool shutdown on SIGHUP reload.

## Core 0.23.2 Release Notes {#core-v0-23-2}

Source: [GitHub.com](https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0232---2016-04-25)

**April 25, 2016** &mdash; Sensu Core version 0.23.2 has been released and is
available for immediate download. Please note the following improvements:

- **IMPROVEMENT:** fixed client socket check result publishing when the client
has a signature. The client signature is now added to the check result payload,
making it valid (see: [#1182][7]).

## Core 0.23.1 Release Notes {#core-v0-23-1}

Source: [GitHub.com](https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0231---2016-04-15)

**April 15, 2016** &mdash; Sensu Core version 0.23.1 has been released and is
available for immediate download. Please note the following improvements:

- **NEW:** a pure-Ruby EventMachine reactor is used when running on Solaris.

## Core 0.23.0 Release Notes {#core-v0-23-0}

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
  {
    "sentinels": [
      {
        "host": "10.0.1.23",
        "port": 26479
      }
    ]  
  }
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

[0]:  https://github.com/sensu/sensu/blob/master/CHANGELOG.md
[1]:  https://www.ruby-lang.org/en/news/2015/12/25/ruby-2-3-0-released/
[2]:  http://redis.io/topics/sentinel
[3]:  redis.html#redis-high-availability-configuration
[4]:  configuration.html#sensu-command-line-interfaces-and-arguments
[5]:  https://github.com/JuanitoFatas/fast-ruby
[6]:  https://github.com/eventmachine/eventmachine/blob/master/CHANGELOG.md#1201-march-15-2016
[7]:  https://github.com/sensu/sensu/issues/1182
[8]:  ../enterprise/integrations/servicenow.html
[9]:  ../enterprise/integrations/puppet.html
[10]: #core-v0-23-2
[11]: #core-v0-23-3
