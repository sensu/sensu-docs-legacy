---
title: "Summary"
version: 0.24
weight: 7
next:
  url: "getting-started"
  text: "Getting Started Guide"
---

# Installation Guide Summary

Congratulations - you have successfully installed and configured the Sensu
services, one or more Sensu clients, and a Sensu dashboard! With this basic
implementation in place, you have the core Sensu framework available for
development, testing and evaluation purposes. What's next?

## Next steps

The installation guide provided manual, step-by-step instructions to help the
user (that's you) learn how Sensu is installed and configured. It would not be
practical to manually install Sensu on every machine you wish to monitor. It was
for this reason that Sensu was designed to be deployed by a configuration
management tool, such as [Puppet][1] or [Chef][2]; see the official [Puppet
module][3] and [Chef cookbook][4] for more information about how to automate
your Sensu deployment.

Depending on your business requirements you may be interested in [learning more
about how Sensu Works][5], or in preparing Sensu for production.

### Build a Comprehensive Telemetry Solution

Conceptually, building out a monitoring solution using Sensu requires one or
more [Sensu servers][6], and automating the installation of Sensu
clients on all of your machines. With this core framework in place, you'll also
need to define [monitoring checks][7] for all of the services in your
application stack (e.g. proxy services, web services, database services, etc).
Additionally, it may be prudent to collect and analyze metrics for the same
services, by creating [metric collection][8] and [metric analysis][9] checks.
Finally, no comprehensive telemetry solution would be complete without
configuring notification routing groups (i.e. who gets notified for what?) and
defining alerting and escalation policies via [Sensu Handlers][10].

### Deploying Sensu into Production Environments

Coming soon. If you have questions about deploying Sensu into production
environments, please contact [Sensu Support][11].

### Hardening Sensu

Coming soon. If you have questions about hardening Sensu, please contact [Sensu
Support][11].

### Scaling Sensu

Coming soon. If you have questions about scaling Sensu, please contact [Sensu
Support][11].

[1]:  http://puppet.com
[2]:  http://www.chef.io
[3]:  https://github.com/sensu/sensu-puppet
[4]:  https://github.com/sensu/sensu-chef
[5]:  ../guides/getting-started/overview.html
[6]:  #scaling-sensu
[7]:  ../guides/getting-started/intro-to-checks.html
[8]:  ../guides/getting-started/intro-to-checks.html#create-a-metric-collection-check
[9]:  ../guides/getting-started/intro-to-checks.html#create-a-metric-analysis-check
[10]: ../guides/getting-started/intro-to-handlers.html
[11]: https://helpdesk.sensuapp.com
