---
title: "0.25 changelog"
description: "Release notes for Sensu Core and Sensu Enterprise releases based
  on Sensu Core version 0.25.x"
version: 0.25
weight: 5
---

# Changelog

_NOTE:	Although we endeavor to keep this combined changelog up-to-date,
	the [official Sensu Core changelog][0] may describe changes not
	yet documented here._

## Releases

- [Core 0.25.7 Release Notes](#core-v0-25-7)
- [Enterprise 1.14.7 Release Notes](#enterprise-v1-14-7)
- [Core 0.25.6 Release Notes](#core-v0-25-6)
- [Enterprise 1.14.6 Release Notes](#enterprise-v1-14-6)
- [Enterprise 1.14.5 Release Notes](#enterprise-v1-14-5)
- [Core 0.25.5 Release Notes](#core-v0-25-5)
- [Enterprise 1.14.4 Release Notes](#enterprise-v1-14-4)
- [Core 0.25.4 Release Notes](#core-v0-25-4)
- [Enterprise 1.14.3 Release Notes](#enterprise-v1-14-3)
- [Core 0.25.3 Release Notes](#core-v0-25-3)
- [Enterprise 1.14.2 Release Notes](#enterprise-v1-14-2)
- [Enterprise 1.14.1 Release Notes](#enterprise-v1-14-1)
- [Core 0.25.2 Release Notes](#core-v0-25-2)
- [Enterprise 1.14.0 Release Notes](#enterprise-v1-14-0)
- [Core 0.25.1 Release Notes](#core-v0-25-1)
- [Core 0.25.0 Release Notes](#core-v0-25-0)

## Core 0.25.7 Release Notes {#core-v0-25-7}

Source: [GitHub.com][25]

**August 9, 2016** &mdash; Sensu Core version 0.25.7 has been released and is
available for immediate download. Please note the following improvements:

### CHANGES {#core-v0-25-7-changes}

- **BUGFIX**: Fixed the Sensu API 204 status response string, changing "No
  Response" to the correct string "No Content". **Fixes: [#1405][26].**

## Enterprise 1.14.7 Release Notes {#enterprise-v1-14-7}

**July 28, 2016** &mdash; Sensu Enterprise version 1.14.4 has been released and
is available for immediate download. Please note the following improvements:

### CHANGES {#enterprise-v1-14-7-changes}

- **NEW**: Built on [Sensu Core version 0.25.6][24].

## Core 0.25.6 Release Notes {#core-v0-25-6}

Source: [GitHub.com][23]

**July 28, 2016** &mdash; Sensu Core version 0.25.6 has been released and is
available for immediate download. Please note the following improvements:

### CHANGES {#core-v0-25-6-changes}

- **BUGFIX**: Check results for unmatched tokens now include an executed
  timestamp.

- **BUGFIX**: API aggregates max_age now guards against check results with a nil
  executed timestamp.

## Enterprise 1.14.6 Release Notes {#enterprise-v1-14-6}

**July 26, 2016** &mdash; Sensu Enterprise version 1.14.4 has been released and
is available for immediate download. Please note the following improvements:

### CHANGES {#enterprise-v1-14-6-changes}

- **BUGFIX**: Added newline event delimiter to event stream integration.

## Enterprise 1.14.5 Release Notes {#enterprise-v1-14-5}

**July 20, 2016** &mdash; Sensu Enterprise version 1.14.5 has been released and
is available for immediate download. Please note the following improvements:

### CHANGES {#enterprise-v1-14-5-changes}

- **NEW**: Built on [Sensu Core version 0.25.5][22]

## Core 0.25.5 Release Notes {#core-v0-25-5}

Source: [GitHub.com][18]

**July 12, 2016** &mdash; Sensu Core version 0.25.5 has been released and is
available for immediate download. Please note the following improvements:

### CHANGES {#core-v0-25-5-changes}

- **BUGFIX**: Reverted a Sensu API race condition fix, it was a red herring.
  Desired behavior has been restored. **See: [#1358][19].**

- **BUGFIX:**: Custom check definition attributes are now included in check
  request payloads, fixing check attribute token substitution for pubsub checks.
  **Fixes: [#1360][20].**

- **BUGFIX:** Transport connectivity issues are now handled while querying the
  Transport for pipe stats for API /info and /health. **See: [#1367][21].**

## Enterprise 1.14.4 Release Notes {#enterprise-v1-14-4}

**June 30, 2016** &mdash; Sensu Enterprise version 1.14.4 has been released and
is available for immediate download. Please note the following improvements:

### CHANGES {#enterprise-v1-14-4-changes}

- **BUGFIX**: Use Java SecureRandom in lieu of JRuby SecureRandom to ensure UUID
  generation is non-blocking
- **BUGFIX**: Catch unexpected exceptions thrown by API HTTPHandler respond
  method

## Core 0.25.4 Release Notes {#core-v0-25-4}

Source: [GitHub.com][16]

**June 20, 2016** &mdash; Sensu Core version 0.25.4 has been released and is
available for immediate download. Please note the following improvements:

### CHANGES {#core-v0-25-4-changes}

- **BUGFIX**: Fixed a race condition in the Sensu API where the `@redis` and
  `@transport` objects were not initialized before serving API requests.

## Enterprise 1.14.3 Release Notes {#enterprise-v1-14-3}

**June 17, 2016** &mdash; Sensu Enterprise version 1.14.3 has been released and
is available for immediate download. Please note the following improvements:

### CHANGES {#enterprise-v1-14-3-changes}

- **NEW**: Built on [Sensu Core version 0.25.3][12].

## Core 0.25.3 Release Notes {#core-v0-25-3}

Source: [GitHub.com][15]

**June 17, 2016** &mdash; Sensu Core version 0.25.3 has been released and is
available for immediate download. Please note the following improvements:

### CHANGES {#core-v0-25-3-changes}

- **BUGFIX**: Fixed a condition where API process was unable to set CORS HTTP
  headers when the API had not been configured (i.e. no `"api": {}` definition
  in configuration).

## Enterprise 1.14.2 Release Notes {#enterprise-v1-14-2}

**June 16, 2016** &mdash; Sensu Enterprise version 1.14.2 has been released and
is available for immediate download. Please note the following improvements:

### CHANGES {#enterprise-v1-14-2-changes}

- **IMPROVEMENT**: The Enterprise Email integration now uses TLSv1.2 for
  STARTTLS and supports additional SSL ciphers.

## Enterprise 1.14.1 Release Notes {#enterprise-v1-14-1}

**June 16, 2016** &mdash; Sensu Enterprise version 1.14.1 has been released and
is available for immediate download. Please note the following improvements:

### CHANGES {#enterprise-v1-14-1-changes}

- **NEW**: Built on [Sensu Core version 0.25.2][10].

## Core 0.25.2 Release Notes {#core-v0-25-2}

Source: [GitHub.com][14]

**June 16, 2016** &mdash; Sensu Core version 0.25.2 has been released and is
available for immediate download. Please note the following improvements:

### CHANGES {#core-v0-25-2-changes}

- **BUGFIX**: The Sensu API now responds to HEAD requests for API GET
routes.
- **BUGFIX**: The Sensu API now responds to unsupported HTTP request methods
with a 404 (Not Found), i.e. PUT.

## Enterprise 1.14.0 Release Notes {#enterprise-v1-14-0}

**June 15, 2016** &mdash; Sensu Enterprise version 1.14.0 has been released and
is available for immediate download. Please note the following improvements:

### IMPORTANT {#enterprise-v1-14-0-important}

This release includes potentially breaking, backwards-incompatible changes:

- This is the first Sensu Enterprise release based on Sensu Core version 0.25.x.
  Please refer to the [Sensu Core version 0.25.0 release notes][8] (below) for
  additional information on potentially breaking changes.

### CHANGES {#enterprise-v1-14-0-changes}

- **NEW**: Built on [Sensu Core version 0.25.1][9].
- **IMPROVEMENT**: Significant Enterprise /metric API route performance
  improvements, reducing network IO, CPU, and memory utilization.
- **IMPROVEMENT**: Reduced Enterprise metric retention from 4 hours to 1 hour,
  as the Enterprise Console HUD currently only displays 30 minutes of data.

## Core 0.25.1 Release Notes {#core-v0-25-1}

Source: [GitHub.com][13]

**June 14, 2016** &mdash; Sensu Core version 0.25.1 has been released and is
available for immediate download. Please note the following improvements:

### CHANGES {#core-v0-25-1-changes}

- **IMPROVEMENT**: the Sensu Core package now includes version 1.2 _and_ 1.3 of
  the Sensu Plugin gem. **Fixes [#1339][11].**
- **BUGFIX**: The Sensu API now sets the HTTP response header "Connection" to
  "close". Uchiwa was experiencing intermittent EOF errors. **Fixes
  [#1340][7].**

## Core 0.25.0 Release Notes {#core-v0-25-0}

Source: [GitHub.com][1]

**June 13, 2016** &mdash; Sensu Core version 0.25.0 has been released and is
available for immediate download. Please note the following improvements:

### IMPORTANT {#core-v0-25-0-important}

This release includes potentially breaking, backwards-incompatible changes:

- The legacy/deprecated Sensu API singular resources (e.g. `/check/:check_name`
  instead of `/checks/:check_name`), have been removed. Singular resources were
  never documented and have not been used by most community tooling (e.g.
  Uchiwa) since the very early Sensu releases (circa 2011-2012).

### CHANGES {#core-v0-25-0-changes}

- **NEW**: [Built-in client de-registration][2]. Sensu client de-registration on
  graceful `sensu-client` process stop is now supported by the Sensu client
  itself (no longer depending on the package init script). The package init
  script-based de-registration functionality still remains, but is considered to
  be deprecated at this time and will be removed in a future release.

  Please note the following example client definition which enables built-in
  client de-registration (via the new client `deregister` definition attribute),
  and sets the deregistration event handler to `deregister_client` (via the new
  client `deregistration` definition attribute):

  ~~~ json
  {
    "client": {
      "name": "i-424242",
      "address": "8.8.8.8",
      "subscriptions": [
        "production",
        "webserver",
        "mysql"
      ],
      "deregister": true,
      "deregistration": {
        "handler": "deregister_client"
      },
      "socket": {
        "bind": "127.0.0.1",
        "port": 3030
      }
    }
  }
  ~~~

  Please refer to the [Sensu client reference documentation][2] for additional
  information on configuring the built-in Sensu client de-registration.
  **Fixes [#1191][3], [#1305][4].**

- **NEW**: The Sensu API has been rewritten to use [EM HTTP Server][5], removing
  Rack and Thin as API runtime dependencies. The API no longer uses Rack async,
  making for cleaner HTTP request logic and much improved HTTP request and
  response logging. **Fixes [#1317][6].**

- **BUGFIX**: Fixed a critical bug in Sensu client `execute_check_command()`
  where a check result would contain a check command with client tokens
  substituted, potentially exposing sensitive/redacted client attribute values.



[?]:  #
[0]:  https://github.com/sensu/sensu/blob/master/CHANGELOG.md
[1]:  https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0250---2016-06-13
[2]:  /docs/0.25/reference/clients.html#deregistration-attributes
[3]:  https://github.com/sensu/sensu/pull/1191
[4]:  https://github.com/sensu/sensu/pull/1305
[5]:  https://github.com/alor/em-http-server
[6]:  https://github.com/sensu/sensu/issues/1317
[7]:  https://github.com/sensu/sensu/issues/1317
[8]:  #core-v0-25-0
[9]:  #core-v0-25-1
[10]: #core-v0-25-2
[11]: https://github.com/sensu/sensu/issues/1339
[12]: #core-v0-25-3
[13]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0251---2016-06-14
[14]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0252---2016-06-16
[15]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0253---2016-06-17
[16]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0254---2016-06-20
[17]: #core-v0-25-4
[18]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0255---2016-07-12
[19]: https://github.com/sensu/sensu/pull/1358
[20]: https://github.com/sensu/sensu/issues/1360
[21]: https://github.com/sensu/sensu/pull/1367
[22]: #core-v0-25-5
[23]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0256---2016-07-28
[24]: #core-v0-25-6
[25]: https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0257---2016-08-09
[26]: https://github.com/sensu/sensu/issues/1405
[27]: #core-v0-25-7
