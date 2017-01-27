---
title: "0.27 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 0.27.x"
version: 0.27
weight: 5
---

# Changelog

## Releases

- [Core 0.27.0 Release Notes](#core-v0-27-0)

## Core 0.27.0 Release Notes {#core-v0-27-0}

Source: [GitHub.com][2]

**January 26, 2017** &mdash; Sensu Core version 0.27.0 has been released and is
available for immediate download. Please note the following improvements:

### IMPORTANT {#core-v0-27-0-important}

This release includes potentially breaking, backwards-incompatible changes:

PACKAGING AND SERVICE MANAGEMENT NOTES HERE.

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

- **NEW**: Added client deregistration attribute status, allowing clients
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

[1]:    https://github.com/sensu/sensu/blob/master/CHANGELOG.md
[2]:	https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0270---2017-01-26
