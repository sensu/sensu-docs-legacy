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

- [Core 1.2.0 Release Notes](#core-v1-2-0)

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
