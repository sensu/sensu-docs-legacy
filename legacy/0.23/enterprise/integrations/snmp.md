---
title: "SNMP"
version: 0.23
weight: 9
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# SNMP Integration

- [Overview](#overview)
  - [Sensu Enterprise MIBs](#sensu-enterprise-mibs)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`snmp` attributes](#snmp-attributes)

## Overview

Send SNMP traps to a SNMP manager. Sensu Enterprise provides two SNMP MIB
(management information base) modules for this integration. The SNMP integration
is capable of creating either SNMPv1 or SNMPv2 traps for Sensu events. By
default, SNMPv2 traps are created unless the integration is configured for
SNMPv1, e.g. `"version": 1`.  The SNMP manager that will be receiving SNMP traps
from Sensu Enterprise should load the appropriate provided MIBs. The Sensu
Enterprise SNMP MIB files can be altered to better fit certain environments and
SNMP configurations.

### Sensu Enterprise MIBs

SNMPv1 MIBs:

- [RFC-1212-MIB.txt](../../files/RFC-1212-MIB.txt)

- [RFC-1215-MIB.txt](../../files/RFC-1215-MIB.txt)

- [SENSU-ENTERPRISE-V1-MIB.txt](../../files/SENSU-ENTERPRISE-V1-MIB.txt)

SNMPv2 MIBs:

- [SENSU-ENTERPRISE-ROOT-MIB.txt](../../files/SENSU-ENTERPRISE-ROOT-MIB.txt)

- [SENSU-ENTERPRISE-NOTIFY-MIB.txt](../../files/SENSU-ENTERPRISE-NOTIFY-MIB.txt)

## Configuration

### Example(s)

The following is an example global configuration for the `snmp` enterprise event
handler (integration).

~~~ json
{
  "snmp": {
    "host": "8.8.8.8",
    "port": 162,
    "community": "public",
    "version": 2
  }
}
~~~

### Integration Specification

#### `snmp` attributes

The following attributes are configured within the `{"snmp": {} }`
[configuration scope][2].

`host`
: description
  : The SNMP manager host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

`port`
: description
  : The SNMP manager trap port (UDP).
: required
  : false
: type
  : Integer
: default
  : `162`
: example
  : ~~~ shell
    "port": 162
    ~~~

`community`
: description
  : The SNMP community string to use when sending traps.
: required
  : false
: type
  : String
: default
  : `public`
: example
  : ~~~ shell
    "community": "private"
    ~~~



[?]:  #
[1]:  /enterprise
[2]:  ../../reference/configuration.html#configuration-scopes
