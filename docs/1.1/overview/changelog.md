---
title: "1.1 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 1.1.x"
version: 1.1
weight: 5
next:
  url: "faq.html"
  text: "Sensu FAQ"
---

# Changelog

## Releases

- [Enterprise 2.7.0 Release Notes](#enterprise-v2-7-0)
- [Core 1.1.0 Release Notes](#core-v1-1-0)

## Enterprise 2.7.0 Release Notes {#enterprise-v2-7-0}

**November 20, 2017** &mdash; Sensu Enterprise version 2.7.0 has been
	released and is available for immediate download. Please note the
	following improvements:

### CHANGES {#enterprise-v2-7-7-changes}

- **IMPROVEMENT**: Now built on Sensu Core 1.1.0

- **IMPROVEMENT**: Integrations now include event data in logged error messages.

- **BUGFIX**: Integrations now use the configured value for
  `api.bind` setting when using the API.

## Core 1.1.0 Release Notes {#core-v1-1-0}

Source: [GitHub.com][2]

**September 27, 2017** &mdash; Sensu Core version 1.1.0 has been released
	and is available for immediate download. Please note the following
	improvements:

### CHANGES {#core-v1-1-0-changes}

- **IMPORTANT**: Sensu packages include Ruby 2.4.1. Upgrading from
	releases of Sensu prior to 1.0.0 will require all plugin or
	extension gems to be re-installed under the new Ruby environment.

- **IMPORTANT**: Sensu packages include [sensu-plugin 2.0.0][3], which
	disables its deprecated filter methods by default, i.e.
	occurrences. Sensu releases since 1.0.0 include built-in filters
	that provide the same functionality with several improvements. The
	built-in filters are ["occurrences"][4] and
	["check_dependencies"][5]. To use the built-in filters, apply them
	to Sensu event handlers via their definition `"filters"`
	attribute, e.g. `"filters": ["occurrences",
	"check_dependencies"]`. These filters can now be used with Sensu
	event handlers that do not use the sensu-plugin library (or Ruby).

- **NEW**: Check hooks, commands run by the Sensu client in response to
	the result of the check command execution. The Sensu client will
	execute the appropriate configured hook command, depending on the
	check execution status (e.g. 1). Valid hook names include (in
	order of precedence): "1"-"255", "ok", "warning", "critical",
	"unknown", and "non-zero". The check hook command output, status,
	executed timestamp, and duration are captured and published in the
	check result. Check hook commands can optionally receive JSON
	serialized Sensu client and check definition data via STDIN.

- **NEW**: Check STDIN. A boolean check definition attribute, "stdin",
	when set to true instructs the Sensu client to write JSON
	serialized Sensu client and check definition data to the check
	command process STDIN. This attribute cannot be used with existing
	Sensu check plugins, nor Nagios plugins etc, as the Sensu client
	will wait indefinitely for the check process to read and close
	STDIN.

- **IMPROVEMENT**: Splayed proxy check request publishing. Users can now
	splay proxy check requests (optional), evenly, over a window of
	time, determined by the check interval and a configurable splay
	coverage percentage. For example, if a check has an interval of
	60s and a configured splay coverage of 90%, its proxy check
	requests would be splayed evenly over a time window of 60s * 90%,
	54s, leaving 6s for the last proxy check execution before the the
	next round of proxy check requests for the same check. Proxy check
	request splayed publishing can be configured with two new check
	definition attributes, within the proxy_requests scope, splay
	(boolean) to enable it and splay_coverage (integer percentage,
	defaults to 90).

- **IMPROVEMENT**: Configurable check output truncation (for storage in
	Redis). Check output truncation can be manually enabled/disabled
	with the check definition attribute "truncate_output",
	e.g."truncate_output": false. The output truncation length can be
	configured with the check definition attribute
	"truncate_output_length", e.g. "truncate_output_length": 1024.
	Check output truncation is still enabled by default for metric
	checks, with "type": "metric".

- **IMPROVEMENT**: Sensu client HTTP socket basic authentication can how
	be applied to all endpoints (not just /settings), via the client
	definition http_socket attribute "protect_all_endpoints", e.g.
	"protect_all_endpoints": true.

- **IMPROVEMENT**: Improved check TTL monitoring performance.

- **IMRPOVEMENT**: The Sensu extension run log event log level is now set
	to debug (instead of info) when the run output is empty and the
	status is 0.

- **BUGFIX**: Added initial timestamp to proxy client definitions. The
	Uchiwa and Sensu dashboards will no longer display "Invalid Date".

- **BUGFIX**: Deleting check history when deleting an associated check result.

[1]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md
[2]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#110---2017-09-27
[3]: https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#v200---2017-03-29
[4]: https://github.com/sensu-extensions/sensu-extensions-occurrences
[5]: https://github.com/sensu-extensions/sensu-extensions-check-dependencies
