---
title: "1.0 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 1.0.x"
version: 1.0
weight: 5
next:
  url: "faq.html"
  text: "Sensu FAQ"
---

# Changelog

## Releases

- [Enterprise 2.6.0 Release Notes](#enterprise-v2-6-0)
- [Core 1.0.3 Release Notes](#core-v1-0-3)
- [Core 1.0.2 Release Notes](#core-v1-0-2)
- [Core 1.0.1 Release Notes](#core-v1-0-1)
- [Core 1.0.0 Release Notes](#core-v1-0-0)

## Core 1.0.3 Release Notes {#core-v1-0-3}

Source: [GitHub.com][7]

**August 25, 2017** &mdash; Sensu Core version 1.0.3 has been released
	and is available for immediate download. Please note the following
	improvements:

### CHANGES {#core-v1-0-3-changes}

- **BUGFIX**: Now using EventMachine version 1.2.5 in order to support
	larger EM timer intervals. EM timers are used by the Sensu check
	scheduler and many other Sensu components.

## Enterprise 2.6.0 Release Notes {#enterprise-v2-6-0}

**July 27, 2017** &mdash; Sensu Enterprise version 2.6.0 has been
	released and is available for immediate download. Please note the
	following improvements:

### CHANGES {#enterprise-v2-6-0-changes}

- **IMPROVEMENT**: Built on Sensu Core 1.0.2.

- **IMPROVEMENT**: Added support for contact routing to every metric
	integration (e.g. InfluxDB, Graphite, OpenTSDB, etc.).

- **IMPROVEMENT**: Sensu Enterprise now loads configuration and validates
	it prior to reloading (SIGHUP). If configuration is determined to
	be invalid prior to reloading, Sensu will report invalid
	configuration definitions, and it will continue to run with its
	existing working configuration.

- **IMPROVEMENT**: Using JRuby 9.1.12.0, for performance enhancements and
	bug fixes.

- **IMPROVEMENT**: Wavefront integration `prefix` option, supporting a
	custom metric name prefix.

- **IMPROVEMENT**: Added Enterprise version to API /info.

## Core 1.0.2 Release Notes {#core-v1-0-2}

Source: [GitHub.com][7]

**July 27, 2017** &mdash; Sensu Core version 1.0.2 has been released
	and is available for immediate download. Please note the following
	improvements:

### CHANGES {#core-v1-0-2-changes}

- **BUGFIX**: Addressed an issue with client keepalive transport
	acknowledgments. We discovered a situation where poor Redis
	performance could negatively impact client keepalive processing,
	potentially triggering a compounding failure that the Sensu server
	is unable to recover from. Moving acknowledgments to the next tick
	of the EventMachine reactor avoids the situation entirely.

## Core 1.0.1 Release Notes {#core-v1-0-1}

Source: [GitHub.com][6]

**July 24, 2017** &mdash; Sensu Core version 1.0.1 has been released
	and is available for immediate download. Please note the following
	improvements:

### CHANGES {#core-v1-0-1-changes}

- **BUGFIX**: Fixed Sensu configuration validation, it is now being
	applied. There was a bug that allowed invalid Sensu configuration
	definitions to be loaded, causing unexpected behaviours.

- **BUGFIX**: Now excluding certain file system directories from the Sensu
	RPM package spec, as they could cause conflicts with other RPM
	packages.

## Core 1.0.0 Release Notes {#core-v1-0-0}

Source: [GitHub.com][2]

**July 11, 2017** &mdash; Sensu Core version 1.0.0 has been released
	and is available for immediate download. Please note the following
	improvements:

### CHANGES {#core-v1-0-0-changes}

- **IMPORTANT**: Sensu packages now include Ruby 2.4.1. Upgrading from
	prior versions of Sensu will require any plugin or extension gems
	to be re-installed under the new Ruby environment.

- **IMPORTANT**: Sensu packages now include [sensu-plugin 2.0.0][3], which
	disables its deprecated filter methods by default, i.e.
	occurrences. Sensu 1.0 includes built-in filters that provide the
	same functionality with several improvements. The built-in filters
	are ["occurrences"][4] and ["check_dependencies"][5]. To use the
	built-in filters, apply them to Sensu event handlers via their
	definition `"filters"` attribute, e.g. `"filters": ["occurrences",
	"check_dependencies"]`. These filters can now be used with Sensu
	event handlers that do not use the sensu-plugin library (or Ruby).

- **NEW**: Added Sensu API event endpoint alias "incidents", e.g.
	/incidents, /incidents/:client/:check.

- **IMPROVEMENT**: Improved Sensu client keepalive configuration
	validation, now including coverage for check low/high flap
	thresholds etc.

- **IMPROVEMENT**: Improved Sensu client socket check result validation,
	now including coverage for check low/high flap thresholds etc.

- **IMPROVEMENT**: The sensu-install tool now notifies users when it is
	unable to successfully install an extension, when the environment
	variable EMBEDDED_RUBY is set to false.

- **IMPROVEMENT**: Added the Sensu RELEASE_INFO constant, containing
	information about the Sensu release, used by the API /info
	endpoint and Server registration.

- **BUGFIX**: Sensu handler severities filtering now accounts for flapping
	events.

- **BUGFIX**: Fixed Sensu Redis connection on error reconnect, no longer
	reusing the existing EventMachine connection handler.

[1]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md
[2]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#100---2017-07-11
[3]: https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#v200---2017-03-29
[4]: https://github.com/sensu-extensions/sensu-extensions-occurrences
[5]: https://github.com/sensu-extensions/sensu-extensions-check-dependencies
[6]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#101---2017-07-24
[7]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#102---2017-07-27
