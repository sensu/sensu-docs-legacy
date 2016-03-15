---
version: 0.21
category: "Enterprise Docs"
title: "Built-in Mutators"
next:
  url: "enterprise-contact-routing"
  text: "Enterprise Contact Routing"
---

# Built-in Mutators in Sensu Enterprise

Sensu Core ships with a set of built-in [mutators](mutators) for transforming event data into JSON, Ruby Hash, or extracting check output. Sensu Enterprise comes with additional mutators, enabling third-party integrations, and providing event handler authors with a set of supported tools with well defined specifications.

## Enterprise mutators

### The output_format mutator {#output-format}

Sensu Enterprise simplifies the process of gaining insightful metrics from complex distributed systems. The `output_format` enterprise mutator makes it possible to mutate collected metrics in various formats from disparate data sources, into a [proprietary intermediate format](#sensu-metric-format) that has been optimized for portability.

The `output_format` enterprise mutator extracts metrics from check result output. Users can specify an output format per check, enabling the use of various check plugins (Nagios plugins, etc.) and data sources. The `output_format` mutator currently supports several mainstream specifications: [Graphite Plaintext][graphite_plaintext], [Nagios PerfData][nagios_perfdata], [OpenTSDB][opentsdb], [Metrics 2.0 as a wire format][metrics20_wire], and [Wizardvan JSON][wizardvan_json].

#### Example output_format filter configuration

The following is an example of how to configure an output format for a metric collection check, one that is making use of a Nagios plugin. This example check not only monitors NTP but also collects several metrics. Note the multiple event handlers: one for notifications (`pagerduty`), another for metric storage (`graphite`).

~~~ json
{
  "checks": {
    "ntp": {
      "command": "/usr/lib/nagios/plugins/check_ntp -H time.nrc.ca",
      "subscribers": [
        "production"
      ],
      "interval": 20,
      "output_format": "nagios_perfdata",
      "handlers": [
        "pagerduty",
        "graphite"
      ]
    }
  }
}
~~~

#### Definition attributes

output_format
: description
  : A metric output format (to be parsed).
: required
  : true
: type
  : String
: allowed values
  : `graphite_plaintext`, `nagios_perfdata`, `opentsdb`, `metrics20_wire`, `wizardvan_json`
: default
  : `graphite_plaintext`
: example
  : ~~~ shell
    "output_format": "graphite_plaintext"
    ~~~

[nagios_perfdata]: http://nagios.sourceforge.net/docs/3_0/perfdata.html
[graphite_plaintext]: http://graphite.readthedocs.org/en/latest/feeding-carbon.html#the-plaintext-protocol
[opentsdb]: http://opentsdb.net/docs/build/html/user_guide/writing.html
[metrics20_wire]: http://metrics20.org/spec/#wire_format
[wizardvan_json]: https://github.com/opower/sensu-metrics-relay#json-metric-format
