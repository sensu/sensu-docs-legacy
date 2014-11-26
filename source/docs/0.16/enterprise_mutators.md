---
version: "0.16"
category: "Enterprise"
title: "Enterprise mutators"
---

# Enterprise mutators

## output_format {#output-format}

The `output_format` enterprise mutator is used to extract metrics from
check result output. Users can specify an output format per check,
enabling the use of various check plugins (Nagios plugins, etc.) and
data sources. The `output_format` mutator currently supports several
mainstream formats: [Nagios PerfData][nagios_perfdata], [Graphite
Plaintext][graphite_plaintext], [OpenTSDB][opentsdb], and [Metrics 2.0
as a wire format][metrics20_wire]. Extracted metrics are mutated into a
common/intermediate format, the Sensu Metric Format. Enterprise
third-party integrations for metrics use the `output_format` mutator,
users must specify an output format for metric checks. Regular Sensu
event handlers can also make use of the `output_format` mutator,
allowing them to expect a single format.

The valid values for `output_format` are:

- `nagios_perf_data`
- `graphite_plaintext`
- `opentsdb`
- `metrics20_wire`

The following is an example of how to configure an output format for a
metric check, one that is making use of a Nagios plugin.

~~~ json
{
    "checks": {
        "ntp": {
            "command": "/usr/lib/nagios/plugins/check_ntp -H time.nrc.ca",
            "subscribers": [
                "all"
            ],
            "interval": 20,
            "output_format": "nagios_perf_data",
            "handlers": [
                "default",
                "graphite"
            ]
        }
    }
}
~~~

The following is an example of how to configure a regular Sensu event
handler to use the `output_format` enterprise mutator.

~~~ json
{
  "handlers": {
      "metrics": {
          "type": "pipe",
          "command": "custom-handler.rb",
          "mutator": "output_format"
      }
  }
}
~~~

### The Sensu Metric Format. {#sensu-metric-format}

`tags|source name value timestamp\n`

- Tags are optional

- Tags are space delimeted key/value pairs, joined by `=`, eg. `dc=iad env=prod`

- Source must be a string, identifying where the measurement was taken

- Name must be an alphanumeric string, but may also contain `.-_`

- Value must be numeric

- Timestamp must be in epoch time, eg. `1403558187`

- Data points are newline delimited, eg. `\n`

The following is an example of two data points. The second data point does not have tags.

~~~
dc=iad env=prod|i-424242 the.answer 42 1403558187
|i-424242 mice.count 2 1403558187
~~~

[nagios_perfdata]: http://nagios.sourceforge.net/docs/3_0/perfdata.html
[graphite_plaintext]: http://graphite.readthedocs.org/en/latest/feeding-carbon.html#the-plaintext-protocol
[opentsdb]: http://opentsdb.net/docs/build/html/user_guide/writing.html
[metrics20_wire]: http://metrics20.org/spec/#wire_format
