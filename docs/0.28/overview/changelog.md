---
title: "0.28 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 0.28.x"
version: 0.28
weight: 5
---

# Changelog

## Releases

- [Enterprise 2.5.2 Release Notes](#enterprise-v2-5-2)
- [Enterprise 2.5.1 Release Notes](#enterprise-v2-5-1)
- [Enterprise 2.5.0 Release Notes](#enterprise-v2-5-0)
- [Core 0.28.5 Release Notes](#core-v0-28-5)
- [Core 0.28.4 Release Notes](#core-v0-28-4)
- [Core 0.28.3 Release Notes](#core-v0-28-3)
- [Core 0.28.2 Release Notes](#core-v0-28-2)
- [Core 0.28.1 Release Notes](#core-v0-28-1)
- [Core 0.28.0 Release Notes](#core-v0-28-0)

## Enterprise 2.5.2 Release Notes {#enterprise-v2-5-2}

**March 24, 2017** &mdash; Sensu Enterprise version 2.5.2 has been
	released and is available for immediate download. Please note the
	following improvements:

### CHANGES {#enterprise-v2-5-2-changes}

- **IMPROVEMENT**: Built on Sensu Core 0.28.5.

- **IMPROVEMENT**: Improved OpsGenie integration API request debug
	logging.

## Enterprise 2.5.1 Release Notes {#enterprise-v2-5-1}

**March 13, 2017** &mdash; Sensu Enterprise version 2.5.1 has been
	released and is available for immediate download. Please note the
	following improvements:

### CHANGES {#enterprise-v2-5-1-changes}

- **IMPROVEMENT**: Built on Sensu Core 0.28.4.

## Enterprise 2.5.0 Release Notes {#enterprise-v2-5-0}

**February 24, 2017** &mdash; Sensu Enterprise version 2.5.0 has been
	released and is available for immediate download. Please note the
	following improvements:

### CHANGES {#enterprise-v2-5-0-changes}

- **IMPROVEMENT**: Built on Sensu Core 0.28.0.

- **IMPROVEMENT**: Added OpenTSDB integration `prefix_source` and `prefix`
	options.

- **BUGFIX**: Contact routing array values now properly override the
	configured default/global integration values.

## Core 0.28.5 Release Notes {#core-v0-28-5}

**March 23, 2017** &mdash; Sensu Core version 0.28.5 has been released and
	is available for immediate download. Please note the following
	changes:

- **BUGFIX**: Fixed check `subdue` and filter `when` features when a time
	window spans over `00:00:00`, crossing the day boundary.

## Core 0.28.4 Release Notes {#core-v0-28-4}

**March 10, 2017** &mdash; Sensu Core version 0.28.4 has been released and
	is available for immediate download. Please note the following
	changes:

- **BUGFIX**: In the interest of addressing a regression causing duplicate
	check execution requests, code added in 0.28.0 to account for task
	scheduling drift has been removed.

## Core 0.28.3 Release Notes {#core-v0-28-3}

**March 9, 2017** &mdash; Sensu Core version 0.28.3 has been released and
	is available for immediate download. Please note the following
	changes:

- **BUGFIX**: The Sensu client now includes check source when tracking in
	progress check executions. These changes are necessary to allow
	the Sensu client to execute on several concurrent proxy check
	requests.

## Core 0.28.2 Release Notes {#core-v0-28-2}

**March 6, 2017** &mdash; Sensu Core version 0.28.2 has been released
  and is available for immediate download. Please note the following
  changes:

- **BUGFIX**: Clients created via /clients API endpoint now have a
  per-client subscription added automatically, ensuring they can be
  silenced.

## Core 0.28.1 Release Notes {#core-v0-28-1}

**March 2, 2017** &mdash; Sensu Core version 0.28.1 has been released
  and is available for immediate download. Please note the following
  changes:

- **BUGFIX**: Check requests with proxy_requests attributes are no
  longer overridden by local check definitions.

- **IMPROVEMENT**: Updated [Oj][3] (used by the sensu-json library) to the
  latest release (2.18.1) for Ruby 2.4 compatibility.

- **IMPROVEMENT**: Updated embedded OpenSSL from [1.0.2j to 1.0.2k][4].

## Core 0.28.0 Release Notes {#core-v0-28-0}

Source: [GitHub.com][2]

**February 23, 2017** &mdash; Sensu Core version 0.28.0 has been released
	and is available for immediate download. Please note the following
	improvements:

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
[3]: https://github.com/ohler55/oj
[4]: https://www.openssl.org/news/openssl-1.0.2-notes.html
