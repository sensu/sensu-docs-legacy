---
title: "EC2"
version: 1.0
weight: 14
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# EC2 Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`ec2` attributes](#ec2-attributes)

## Overview

Deregister Sensu clients from the client registry, if they no longer have an
associated [Amazon Web Services (AWS)][2] EC2 instance in the allowed state(s).
This enterprise handler (integration) will only work if Sensu clients are named
using the EC2 instance ID, for the instance on which they reside. The `ec2`
enterprise handler requires valid [AWS IAM user credentials][3] with the EC2
describe instances action in a policy, e.g. `ec2:DescribeInstances`.

## Configuration

### Example(s)

The following is an example global configuration for the `ec2` enterprise
handler (integration).

~~~ json
{
  "ec2": {
    "region": "us-west-2",
    "access_key_id": "AlygD0X6Z4Xr2m3gl70J",
    "secret_access_key": "y9Jt5OqNOqdy5NCFjhcUsHMb6YqSbReLAJsy4d6obSZIWySv",
    "allowed_instance_states": ["running"],
    "timeout": 10
  }
}
~~~

### Integration Specification

_NOTE: the following integration definition attributes may be overwritten by
the corresponding Sensu [client definition `ec2` attributes][4], which are
included in [event data][5]._

#### `ec2` attributes

The following attributes are configured within the `{"ec2": {} }` [configuration
scope][6].

`region`
: description
  : The AWS EC2 region to query for EC2 instance state(s).
: required
  : false
: type
  : String
: default
  : `us-east-1`
: example
  : ~~~ shell
    "region": "us-west-1"
    ~~~

`access_key_id`
: description
  : The AWS IAM user access key ID to use when querying the EC2 API.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "access_key_id": "AlygD0X6Z4Xr2m3gl70J"
    ~~~

`secret_access_key`
: description
  : The AWS IAM user secret access key to use when querying the EC2 API.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "secret_access_key": "y9Jt5OqNOqdy5NCFjhcUsHMb6YqSbReLAJsy4d6obSZIWySv"
    ~~~

`allowed_instance_states`
: description
  : An array of allowed EC2 instance states. Each array item must each be a
    string. Any other state(s) will cause the Sensu client to be deregistered.
: required
  : false
: type
  : Array
: allowed values
  : `running`, `stopping`, `stopped`, `shutting-down`, `terminated`,
    `rebooting`, `pending`
: default
  : `["running"]`
: example
  : ~~~ shell
    "allowed_instance_states": ["running", "rebooting"]
    ~~~

`timeout`
: description
  : The handler execution duration timeout in seconds (hard stop).
: required
  : false
: type
  : Integer
: default
  : `10`
: example
  : ~~~ shell
    "timeout": 30
    ~~~


[?]:  #
[1]:  /enterprise
[2]:  http://aws.amazon.com?ref=sensu-enterprise
[3]:  http://aws.amazon.com/iam/
[4]:  ../../reference/clients.html#ec2-attributes
[5]:  ../../reference/events.html#event-data
[6]:  ../../reference/configuration.html#configuration-scopes
