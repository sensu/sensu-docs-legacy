---
title: "0.29 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 0.29.x"
version: 0.29
weight: 5
---

# Changelog

## Releases

- [Core 0.29.0 Release Notes](#core-v0-29-0)

## Core 0.29.0 Release Notes {#core-v0-29-0}

Source: [GitHub.com][2]

**April 7, 2017** &mdash; Sensu Core version 0.29.0 has been released
	and is available for immediate download. Please note the following
	improvements:

### CHANGES {#core-v0-29-0-changes}

- **IMPORTANT**: Sensu packages now include Ruby 2.4.1. Upgrading from
	prior versions of Sensu will require any plugin or extension gems
	to be re-installed under the new Ruby environment.

- **IMPORTANT**: Sensu packages now include [sensu-plugin 2.0.0][3], which
	disables its deprecated filter methods by default, i.e.
	occurrences. Sensu 0.29 includes built-in filters that provide the
	same functionality with several improvements. The built-in filters
	are ["occurrences"][4] and ["check_dependencies"][5]. To use the
	built-in filters, apply them to Sensu event handlers via their
	definition `"filters"` attribute, e.g. `"filters": ["occurrences",
	"check_dependencies"]`. These filters can now be used with Sensu
	event handlers that do not use the sensu-plugin library (or Ruby).

- **IMPROVEMENT**: Sensu server tasks, replacing the Sensu server leader
	functionality, distributing certain server responsibilities
	amongst the running Sensu servers. A server task can only run on
	one Sensu server at a time. Sensu servers partake in an election
	process to become responsible for one or more tasks. A task can
	failover to another Sensu server.

- **IMPROVEMENT**: Sensu API response object filtering for any GET
	request. Filtering is done with one or more dot notation query
	parameters, beginning with `filter.`, to specify object attributes
	to filter by, e.g.
	`/events?filter.client.environment=production&filter.check.contact=ops`.

- **NEW**: Added API endpoint GET `/settings` to provided the APIs
	running configuration. Sensitive setting values are redacted by
	default, unless	the query parameter `redacted` is set to `false`,
	e.g. `/settings?redacted=false`.

- **IMPROVEMENT**: Added support for invalidating a Sensu client when
	deleting it via the Sensu API DELETE `/clients/:name` endpoint,
	disallowing further client keepalives and check results until the
	client is either successfully removed from the client registry or
	for a specified duration of time. To invalidate a Sensu client
	until it is deleted, the query parameter `invalidate` must be set
	to `true`, e.g. `/clients/app01.example.com?invalidate=true`. To
	invalidate the client for a certain amount of time (in seconds),
	the query parameter `invalidate_expire` must be set as well, e.g.
	`/clients/app01.example.com?invalidate=true&invalidate_expire=300`.

- **IMPROVEMENT**: Added a Sensu settings hexdigest, exposed via the Sensu
	API GET `/info`	endpoint, providing a means to determine if a
	Sensu server's configuration differs from the rest.

- **IMPROVEMENT**: Added a proxy argument to `sensu-install`. To use a
	proxy for Sensu plugin and extension installation with
	`sensu-install`, use the `-x` or `--proxy` argument, e.g.
	`sensu-install -e statsd --proxy http://proxy.example.com:8080`.

- **IMPROVEMENT**: Added support for issuing proxy check requests via the
	Sensu API POST `/request` endpoint.

- **IMPROVEMENT**: The Sensu API now logs response times.

- **IMPROVEMENT**: The Sensu API now returns a 405 (Method Not Allowed)
	when an API endpoint does not support a HTTP request method, e.g.
	`PUT`, and sets the HTTP header "Allow" to indicate which HTTP
	request methods are supported by the requested endpoint.

- **IMPROVEMENT**: Added a built-in filter for check dependencies,
	`check_dependencies`, which implements the check dependency
	filtering logic in the Sensu Plugin library.

- **IMPROVEMENT**: Added default values for Sensu CLI options
	`config_file` (`"/etc/sensu/config.json"`) and `config_dirs`
	(`["/etc/sensu/conf.d"]`). These defaults are only applied when
	the associated file and/or directory exist.

- **BUGFIX**: The built-in filter `occurrences` now supports `refresh` for
	flapping events (action `flapping`).

- **BUGFIX**: Force the configured Redis port to be an integer, as some
	users make the mistake of using a string.

[1]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md
[2]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0290---2017-03-29
[3]: https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#v200---2017-03-29
[4]: https://github.com/sensu-extensions/sensu-extensions-occurrences
[5]: https://github.com/sensu-extensions/sensu-extensions-check-dependencies
