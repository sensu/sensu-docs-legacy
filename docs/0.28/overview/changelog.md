---
title: "0.28 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 0.28.x"
version: 0.28
weight: 5
---

# Changelog

## Releases

- [Enterprise 2.5.0 Release Notes](#enterprise-v2-5-0)
- [Core 0.28.0 Release Notes](#core-v0-28-0)

## Enterprise 2.4.0 Release Notes {#enterprise-v2-4-0}

**February 24, 2017** &mdash; Sensu Enterprise version 2.5.0 has been
	released and is available for immediate download. Please note the
	following improvements:

### CHANGES {#enterprise-v2-5-0-changes}

- **IMPROVEMENT**: Built on Sensu Core 0.28.0.

- **IMPROVEMENT**: Added OpenTSDB integration `prefix_source` and `prefix`
	options.

- **BUGFIX**: Contact routing array values now properly override the
	configured default/global integration values.

## Core 0.28.0 Release Notes {#core-v0-28-0}

Source: [GitHub.com][2]

**January 26, 2017** &mdash; Sensu Core version 0.28.0 has been released and is
available for immediate download. Please note the following improvements:

### CHANGES {#core-v0-28-0-changes}

- **IMPROVEMENT**: Added proxy check requests to improve Sensu's ability
	to monitor external resources that have an associated Sensu proxy
	client. Publish a check request to the configured `subscribers`
	(e.g. `["round-robin:snmp_pollers"]`) for every Sensu client in
	the registry that matches the configured client attributes in
	`client_attributes` on the configured `interval` (e.g. `60`).
	Client tokens in the check definition (e.g. `"check-snmp-if.rb -h
	:::address::: -i eth0"`) are substituted prior to publishing the
	check request. The check request check source is set to the client
	name.

- **IMPROVEMENT**: Schedule check requests and standalone executions with
	the Cron syntax.

- **IMPROVEMENT**: Added the Sensu server registry, containing information
	about the running Sensu servers. Information about the Sensu
	servers is now accessible via the Sensu API /info endpoint.

- **IMPROVEMENT**: Added two optional attributes to Sensu API POST
	/request, "reason" and "creator", for additional context. The
	check request reason and creator are added to the check request
	payload under "api_requested" and become part of the check result.

- **IMPROVEMENT**: Added event IDs to event handler log events for
	additional context, making it easier to trace an event through the
	Sensu pipeline.

- **BUGFIX**: The Sensu interval timers, used for scheduling tasks, now
	account for drift. The check request and standalone execution
	scheduler timers are now more accurate.

- **BUGFIX**: Fixed a bug in the Sensu deep_merge() method that was
	responsible for mutating arrays of the original provided objects.

[1]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md
[2]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0280---2017-02-23
