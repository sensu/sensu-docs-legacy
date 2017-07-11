---
title: "1.0 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 1.0.x"
version: 1.0
weight: 5
---

# Changelog

## Releases

- [Core 1.0.0 Release Notes](#core-v1-0-0)

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
