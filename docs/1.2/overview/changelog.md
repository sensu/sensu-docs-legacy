---
title: "1.2 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 1.2.x"
version: 1.2
weight: 5
next:
  url: "faq.html"
  text: "Sensu FAQ"
---

# Changelog

## Releases

- [Enterprise 2.8.3 Release Notes](#enterprise-v2-8-3)
- [Enterprise 2.8.2 Release Notes](#enterprise-v2-8-2)
- [Core 1.2.1 Release Notes](#core-v1-2-1)
- [Enterprise 2.8.1 Release Notes](#enterprise-v2-8-1)
- [Enterprise 2.8.0 Release Notes](#enterprise-v2-8-0)
- [Core 1.2.0 Release Notes](#core-v1-2-0)

## Enterprise 2.8.3 Release Notes {#enterprise-v2-8-3}

**March 7, 2017** &mdash; Sensu Enterprise version 2.8.3 has been
	released and is available for immediate download. Please note the
	following improvements:

### CHANGES {#enterprise-v2-8-3-changes}

- **IMPROVEMENT**: Added context to JIRA integration log events, including
event/event_id and contact name.

### FIXED {#enterprise-v2-8-3-fixed}

- Fixed an OpsGenie integration bug, now adding a contact name prefix to
OpsGenie alert aliases so alerts are deduplicated per contact.

## Enterprise 2.8.2 Release Notes {#enterprise-v2-8-2}

**February 9, 2017** &mdash; Sensu Enterprise version 2.8.2 has been
	released and is available for immediate download. Please note the
	following improvements:

### FIXED {#enterprise-v2-8-2-changes}

- **SECURITY FIX:** Built on Sensu Core 1.2.1 to address [CVE-2018-1000060](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-1000060).  

## Core 1.2.1 Release Notes {#core-v1-2-1}

**February 9, 2017** &mdash; Sensu Core version 1.2.1 has been
	released and is available for immediate download. Please note
	the following improvements:

### FIXED {#core-v1-2-1-changes}

- **SECURITY FIX**: Sensu's configuration redaction function failed to
  handle key/value pairs in deeply nested data structures, resulting in
  sensitive configuration data (e.g. passwords) being logged in clear-text.
  The redaction function now handles the necessary recursion to address
  this vulnerability.

  This vulnerability is documented as [CVE-2018-1000060](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-1000060).

## Enterprise 2.8.1 Release Notes {#enterprise-v2-8-1} 

**January 24, 2017** &mdash; Sensu Enterprise version 2.8.1 has been
	released and is available for immediate download. Please note the
	following improvements:

### FIXED {#enterprise-v2-8-1-changes}

- The OpsGenie alerting integration was accumulating additional tags 
  for every event handled. One symptom of this behavior would be seeing
  alerts tagged with multiple severities. OpsGenie alert tags will 
  now be unique to the Sensu. event they represent.

## Enterprise 2.8.0 Release Notes {#enterprise-v2-8-0}

**December 18, 2017** &mdash; Sensu Enterprise version 2.8.0 has been
	released and is available for immediate download. Please note the
	following improvements:

### CHANGES {#enterprise-v2-8-0-changes}

- **IMPROVEMENT**: The InfluxDB and Graphite integrations now support
	event annotations, for adding Sensu event context to graphs. Any
	check, even those that do not produce metrics, can now use the
	"influxdb" and "graphite" event handlers to record their events in
	the respective time-series database.

- **IMPROVEMENT**: The Slack integration now supports using an ERB
	template for notification Slack attachment text, e.g. `"filters":
	{"text": "/etc/sensu/slack_text.erb"}`.

- **IMPROVEMENT**: The Email integration now supports HTML body content,
	with a configurable email content type, e.g. `"content_type":
	"text/html"`.

- **IMPROVEMENT**: The InfluxDB, OpenTSDB, and Wavefront integrations now
	support configurable tags, which get added to every metric point,
	e.g `"tags": {"dc": "us-central-1"}`

- **IMPROVEMENT**: The Event Stream integration now supports filtering OK
	keepalives, e.g. `"filter_ok_keepalives": true`.

- **IMPROVEMENT**: Built on Sensu Core 1.2.0.

## Core 1.2.0 Release Notes {#core-v1-2-0}

Source: [GitHub.com][2]

**December 5, 2017** &mdash; Sensu Core version 1.2.0 has been
	released and is available for immediate download. Please note
	the following improvements:

### CHANGES {#core-v1-2-0-changes}

- **NEW**: Scheduled maintenance, Sensu now gives users the ability to
	silence a check and/or client subscriptions at a predetermined
	time (begin epoch timestamp), with an optional expiration (in
	seconds), enabling users to silence events in advance for
	scheduled maintenance windows.

- **NEW**: The Sensu API now logs the "X-Request-ID" header, making it
	much easier to trace a request/response. If the API client does
	not provide a request ID, the API generates one for the request
	(UUID).

- **IMPROVEMENT**: The Sensu API /results/* endpoints now include check
	history in the result data.

- **IMPROVEMENT**: Check token substitution is now supported in check
	"subdue".

[1]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md
[2]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#120---2017-12-05
