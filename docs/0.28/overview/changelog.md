---
title: "0.27 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 0.27.x"
version: 0.27
weight: 5
---

# Changelog

## Releases

- [Enterprise 2.4.0 Release Notes](#enterprise-v2-4-0)
- [Core 0.27.1 Release Notes](#core-v0-27-1)
- [Core 0.27.0 Release Notes](#core-v0-27-0)

## Enterprise 2.4.0 Release Notes {#enterprise-v2-4-0}

**February 17, 2017** &mdash; Sensu Enterprise version 2.4.0 has been
	released and is available for immediate download. Please note the
	following improvements:

### CHANGES {#enterprise-v2-4-0-changes}

- **IMPROVEMENT**: Built on Sensu Core 0.27.1.

## Core 0.27.1 Release Notes {#core-v0-27-1}

Source: [GitHub.com][9]

**February 17, 2017** &mdash; Sensu Core version 0.27.1 has been released
	and is available for immediate download. Please note the following
	improvements:

### CHANGES {#core-v0-27-1-changes}

- **IMPROVEMENT**: Failed pipe handler executions are now logged with the
	error log level.

- **IMPROVEMENT**: Sensu server now adds a unique per-client subscription to
	client keepalives when missing. This is to enable built-in event
	silencing for older Sensu clients (< 0.26).

- **BUGFIX**: Check subdue and filter when time windows now account for
	GMT offsets.

- **BUGFIX**: Non UTF-8 characters in check tokens are now removed.

- **BUGFIX**: Fixed filter name logging when an event is filtered.

## Core 0.27.0 Release Notes {#core-v0-27-0}

Source: [GitHub.com][2]

**January 26, 2017** &mdash; Sensu Core version 0.27.0 has been released and is
available for immediate download. Please note the following improvements:

### IMPORTANT {#core-v0-27-0-important}

This release includes potentially breaking, backwards-incompatible changes:

- **NEW**: Sensu is now packaged specifically for each supported platform
	version and architecture; previously, single packages were built
	for each platform and architecture using the oldest supported
	platform version. Accordingly, package repository structures have
	changed to support per-platform-version packages. See the
	[platforms page][3] for links to updated installation instructions.

- **NEW**: On platforms where systemd is the default init, Sensu now
	provides systemd unit files instead of sysv init scripts.

- **NOTE**: The transition of service management from sysv to systemd may
	initially cause an error when restarting Sensu services. To
	avoid this, please be sure to stop Sensu services before
	upgrading to Sensu 0.27 and starting them again.

- **REMOVED**: The embedded runit service supervisor is no longer included
	in Sensu packages for Linux platforms.

- **REPLACED**: The [sensu-omnibus project][4] has superseded sensu-build as
	the tool chain for building official Sensu packages. This project
	uses [Travis CI][5] to automate package builds using a combination of
	[Test Kitchen][6], [Chef][7] and [Omnibus][8] tools.

- **IMPROVEMENT**: Sensu packages for Windows now include Ruby 2.3.0,
	upgraded from Ruby 2.0.0 in prior versions of Sensu.

- **IMPROVEMENT**: Sensu packages for Windows now include winsw 2.0.1,
	upgraded from winsw 1.16. This version includes a number of changes
	which should help to address issues around orphaned processes.

### CHANGES {#core-v0-27-0-changes}

- **NEW**: Added a Sensu client HTTP socket for check result input and
	informational queries. The client HTTP socket provides several
	endpoints, `/info`, `/results`, and `/settings`. Basic
	authentication is supported, which is required for certain
	endpoints, i.e. `/settings`. The client HTTP socket is
	configurable via the Sensu client definition, `"http_socket": {}`.

- **NEW**: Added API endpoint `/silenced/ids/:id` for fetching a silence
	entry by ID.

- **NEW**: Added check attribute `ttl_status`, allowing checks to set a
	different TTL event check status (default is `1` warning).

- **NEW**: Added client deregistration attribute `status`, allowing clients
	to set a different event check status for their deregistration
	events (default is `1` warning).

- **NEW**: Added Rubygems cleanup support to `sensu-install`, via the
	command line argument `-c` or `--clean` when installing one or
	more plugins and/or extensions. If a version is provided for the
	plugin(s) or extension(s), all other installed versions of them
	will be removed, e.g. `sensu-install -e snmp-trap:0.0.23 -c`. If a
	version is not provided, all installed versions except the latest
	will be removed.

- **IMPROVEMENT**: Hostnames are now resolved prior to making connection
	attempts, this applies to the Sensu Transport (i.e. RabbitMQ) and
	Redis connections. This allows Sensu to handle resolution failures
	and enables failover via DNS and services like Amazon AWS
	ElastiCache.

- **IMPROVEMENT**: Added the filter name to event filtered log events.

- **IMPROVEMENT**: Check TTL events now have the check interval overridden
	to the TTL monitoring interval, this change allows event
	occurrence filtering to work as expected.

- **BUGFIX**: Silenced resolution events with silencing
	`"expire_on_resolve": true` are now handled.

[1]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md
[2]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0270---2017-01-26
[3]: ../platforms
[4]: https://github.com/sensu/sensu-omnibus
[5]: https://travis-ci.org
[6]: https://github.com/test-kitchen/test-kitchen
[7]: https://github.com/chef/chef
[8]: https://github.com/chef/omnibus
[9]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0271---2017-02-17
