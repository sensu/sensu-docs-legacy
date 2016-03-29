---
version: 0.22
category: "Overview"
title: "Sensu 0.22.x changelog"
info:
warning:
danger:
---

# Sensu Core version 0.22.x changelog

## 0.22.2 Release Notes {#v0-22-2}

Source: [GitHub.com](https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0222---2016-03-16)

**March 16, 2016** &mdash; Sensu Core version 0.22.2 has been released and is
available for immediate download. Please note the following improvements:

- **BUGFIX:** FFI library loading no longer causes a load error on AIX &
  Solaris.

- Removed unused cruft from extension API `run()` and `safe_run()`. Optional
  `options={}` was never implemented in Sensu Core and event data `dup()` never
  provided the necessary protection that it claimed (only top level hash
  object).

## 0.22.1 Release Notes {#v0-22-1}

Source: [GitHub.com](https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0221---2016-03-01)

**March 01, 2016** &mdash; Sensu Core version 0.22.1 has been released and is
available for immediate download. Please note the following improvements:

- Performance improvements. Using frozen constants for common values and
  comparisons. Reduced the use of block arguments for callbacks.

- Improved RabbitMQ transport channel error handling.

- Fixed client signatures inspection/comparison when upgrading from a previous
  release.

## 0.22.0 Release Notes {#v0-22-0}

Source: [GitHub.com](https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0220---2016-01-29)

**January 29, 2016** &mdash; Sensu Core version 0.22.0 has been released and is
available for immediate download. Please note the following improvements:

- **NEW:** Client registration events are optionally created and processed
  (handled, etc.) when a client is first added to the client registry. To enable
  this functionality, configure a `"registration"` handler definition on Sensu
  server(s), or define a client specific registration handler in the client
  definition, e.g. `{"client": "registration": {"handler": "debug"}}`.

- **NEW:** Client auto de-registration on sensu-client process stop is now
  supported by the Sensu package init script. Setting
  `CLIENT_DEREGISTER_ON_STOP=true` and `CLIENT_DEREGISTER_HANDLER=example` in
  `/etc/default/sensu` will cause the Sensu client to publish a check result to
  trigger the event handler named `"example"`, before its process stops.

- **NEW:** Added support for Sensu client signatures, used to sign client
  keepalive and check result transport messages, for the purposes of source
  (publisher) verification. The client definition attribute `"signature"` is used
  to set the client signature, e.g. `"signature": "6zvyb8lm7fxcs7yw"`. A client
  signature can only be set once, the client must be deleted from the registry
  before its signature can be changed or removed. Client keepalives and check
  results that are not signed with the correct signature are logged (warn) and
  discarded. This feature is NOT a replacement for existing and proven security
  measures.

- **NEW:** The Sensu plugin installation tool, `sensu-install`, will no longer
  install a plugin if a or specified version has already been installed.

- **NEW:** The Sensu client socket now supports UTF-8 encoding.
