---
title: "0.24 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 0.24.x"
version: 0.24
weight: 5
---

# Changelog

_NOTE:	Although we endeavor to keep this combined changelog up-to-date,
	the [official Sensu Core changelog][0] may describe changes not
	yet documented here._

## Releases

- [Enterprise 1.13.0 Release Notes](#enterprise-v1-13-0)
- [Core 0.24.1 Release Notes](#core-v0-24-1)
- [Core 0.24.0 Release Notes](#core-v0-24-0)

## Enterprise 1.13.0 Release Notes {#enterprise-v1-13-0}

**June 9, 2016** &mdash; Sensu Enterprise version 1.13.0 has been released and
is available for immediate download. Please note the following improvements:

### IMPORTANT {#enterprise-v1-13-0-important}

This release includes potentially breaking, backwards-incompatible changes:

- This is the first Sensu Enterprise release based on Sensu Core version 0.24.x.
  Please refer to the [Sensu Core version 0.24.0][37] release notes for
  additional information on potentially breaking changes. This release requires
  Sensu Enterprise Dashboard 1.9.8 or higher. 

### CHANGES {#enterprise-v1-13-0-important}

- **NEW:** Built on [Sensu Core 0.24.1][38].

- **NEW:** [Event Stream integration][39]. The Sensu Enterprise "event stream"
  integration sends **all** Sensu events to a remote TCP socket for complex
  event processing (e.g. "stream processing") and/or long-term storage. Please
  refer to the [Event Stream integration reference documentation][39] for
  additional information.

- **NEW:** [Graylog integration][40]. The Sensu Enterprise Graylog integration
  sends Sensu events to a a Graylog Raw/Plaintext TCP input. Please refer to the
  [Graylog integration reference documentation][40] for additional information.

- **IMPROVEMENT:** [ServiceNow integration][41] adds support for configurable
  "incident table" name (previously hard-coded to `"incident"`), for
  organizations with customized ServiceNow configurations.

- **IMMPROVEMENT:** Built on JRuby 9K.

## Core 0.24.1 Release Notes {#core-v0-24-1}

Source: [GitHub.com][36]

**June 7, 2016** &mdash; Sensu Core version 0.24.1 has been released and is
available for immediate download. Please note the following improvements:

- **BUGFIX:** Fixed a critical bug in Sensu server `resume()` which caused the
  server to crash when querying the state of the Sensu Transport connection
  before it had been initialized. **Resolves [#1321][34].**

- **IMPROVEMENT:** Updated references to unmatched tokens, i.e. check result
  output message, to better represent the new scope of token substitution.
  **Resolves [#1322][35].**

## Core 0.24.0 Release Notes {#core-v0-24-0}

Source: [GitHub.com][1]

**June 6, 2016** &mdash; Sensu Core version 0.24.0 has been released and is
available for immediate download. Please note the following improvements:

### IMPORTANT {#core-v0-24-0-important}

This release includes potentially breaking, backwards-incompatible changes:

- Sensu [check aggregates][2] have been completely redesigned. Users who are
  using check aggregates may need to review these changes before upgrading.
  [Uchiwa][3] users should install version 0.15 or higher before upgrading to
  Sensu Core version 0.24.0. See below for additional information.

- Sensu [event `id`s][4] are no longer unique to each occurrence of an event.
  Event `id`s are now persistent for the duration of an event (per client/check
  pair), until the event is resolved. See below for additional information.

- The Sensu [/health (GET) API endpoint][5] has been updated such that failed
  health checks now respond with an [`412 (Precondition Failed)` HTTP response
  code][6] instead of a [`503 (Service Unavailable)` response code][7].
  Third-party services and/or custom scripts may need to be updated accordingly.

- The Sensu services and corresponding service management scripts have been
  updated to use the new `--validate_config` command line option which uses
  strong configuration validation (i.e. do not start if configuration is in an
  invalid state). See below for additional information.

### CHANGES {#core-v0-24-0-changes}

- **NEW:** Named aggregates. Check [aggregates 2.0][8] are here! At long last,
  Sensu [check aggregates][2] have been updated to support standalone checks, as
  well as a number of new use cases. Please refer to the [check aggregates
  reference documentation][2] for additional information. **Resolves [#803][9],
  [#915][10], [#1041][11], [#1070][12], [#1187][13], and [#1218][8].**

- **NEW:** Persistent [event IDs][4]. Event occurrences for a client/check pair
  will now have the same event ID until the event is resolved (instead of a
  unique event ID for each occurrence of an event). Please refer to the [Event
  specification reference documentation][14] for additional information.
  **Resolves [#1196][15].**

- **NEW:** Strong configuration validation. Added a new `--validate_config` CLI
  option/argument to cause Sensu to validate configuration settings and exit
  with the appropriate exit code (e.g. `2` for invalid). This feature is now
  used when restarting a Sensu service to first validate the new configuration
  before stopping the running service (i.e. to prevent restarts if the
  configuration is invalid). Please refer to the [Sensu service command line
  interface reference documentation][16] for additional information. **Resolves
  [#1244][17], [#1254][18].**

- **NEW:** Proxy check origins. Events for [proxy clients][19] will now have a
  check `origin` attribute, set to the client name of the result producer.
  Please refer to the [Event data specification reference documentation][20] for
  additional information. **Resolves [#1075][21].**

- **NEW:** Improved Sensu check token substitution. Sensu [check token
  substitution][22] is now supported in every check definition attribute value
  (no longer just the check `command` attribute). Please refer to the [check
  token substitution reference documentation][22] for additional information.
  **Resolves [#1281][23].**

- **NEW:** Sensu `/clients (POST)` API endpoint can now create clients in the
  client registry that are expected to produce keepalives, and validates clients
  with the Sensu Settings client definition validator. A new [check `keepalives`
  attribute][33] called has also been added, which allows client keepalives to
  be disabled on a per-client basis. **Resolves [#1203][24].**


- **IMPROVEMENT:** Configurable Sensu Spawn concurrent child process limit
  (checks, mutators, & pipe handlers). The default limit is still 12 and the
  EventMachine threadpool size is automatically adjusted to accommodate a larger
  limit. **Resolves [#1002][25].**

- **IMPROVEMENT:** Event data check type now explicitly defaults to `standard`.
  **Resolves [#1025][26].**

- **IMPROVEMENT:** Improved tracking of in progress check result processing,
  eliminates the potential for losing check results when restarting the Sensu
  server service. **Resolves [#1165][27].**

- **IMPROVEMENT:** Updated [Thin][28] (used by Sensu API) to the latest release,
  version 1.6.4. **Resolves [#1122][29].**

- **IMPROVEMENT:** [JrJackson][30] is now used to parse JSON when Sensu is
  running on JRuby.

- **IMPROVEMENT:** The Sensu API now listens immediately on service start, even
  before it has successfully connected to Redis and the Sensu Transport. It will
  now respond with a `500 (Internal Server Error)` HTTP response code and a
  descriptive error message when it has not yet initialized its connections or
  it is reconnecting to either Redis or the Sensu Transport. The [Health and
  Info API][31] endpoints will still respond normally while reconnecting.
  **Resolves [#1215][32].**


[?]:  #
[0]:  https://github.com/sensu/sensu/blob/master/CHANGELOG.md
[1]:  https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0240---2016-06-06
[2]:  /docs/0.24/reference/aggregates.html
[3]:  https://uchiwa.io/
[4]:  /docs/0.24/reference/events.html#event-data-specification
[5]:  /docs/0.24/api/health-and-info-api.html#health-get
[6]:  https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.4.13
[7]:  https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.5.4
[8]:  https://github.com/sensu/sensu/issues/1218
[9]:  https://github.com/sensu/sensu/issues/803
[10]: https://github.com/sensu/sensu/issues/915
[11]: https://github.com/sensu/sensu/issues/1041
[12]: https://github.com/sensu/sensu/issues/1070
[13]: https://github.com/sensu/sensu/issues/1187
[14]: /docs/0.24/reference/events.html#event-data-specification
[15]: https://github.com/sensu/sensu/issues/1196
[16]: /docs/0.24/reference/configuration.html#sensu-command-line-interfaces-and-arguments
[17]: https://github.com/sensu/sensu/issues/1244
[18]: https://github.com/sensu/sensu/issues/1254
[19]: /docs/0.24/reference/clients.html#proxy-clients
[20]: /docs/0.24/reference/events.html#check-attributes
[21]: https://github.com/sensu/sensu/issues/1275
[22]: /docs/0.24/reference/checks.html#check-token-substitution
[23]: https://github.com/sensu/sensu/issues/1281
[24]: https://github.com/sensu/sensu/issues/1203
[25]: https://github.com/sensu/sensu/issues/1002
[26]: https://github.com/sensu/sensu/issues/1025
[27]: https://github.com/sensu/sensu/issues/1165
[28]: http://code.macournoyer.com/thin/
[29]: https://github.com/sensu/sensu/issues/1122
[30]: https://github.com/guyboertje/jrjackson
[31]: /docs/0.24/api/health-and-info-api.html
[32]: https://github.com/sensu/sensu/issues/1215
[33]: /docs/0.24/reference/clients.html#client-definition-specification
[34]: https://github.com/sensu/sensu/issues/1321
[35]: https://github.com/sensu/sensu/issues/1322
[36]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0241---2016-06-07
[37]: #core-v0-24-0
[38]: #core-v0-24-1
[39]: /docs/0.24/enterprise/integrations/event_stream.html
[40]: /docs/0.24/enterprise/integrations/graylog.html
[41]: /docs/0.24/enterprise/integrations/servicenow.html
