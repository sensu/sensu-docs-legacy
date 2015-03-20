---
version: 0.17
category: "Installation Guide"
title: "Installation Summary"
next:
  url: "getting-started"
  text: "Getting Started Guide"
info:
warning:
danger:
---

# Overview

Congratulations - you have successfully installed and configured the Sensu services, one or more Sensu clients, and a Sensu dashboard! With this basic implementation in place, you have the core Sensu framework available for development, testing and evaluation of your monitoring needs. What's next? 

# Next steps 

The installation guide provided manual, step-by-step instructions to help the user (that's you) learn how Sensu is installed and configured. It would not be practical to manually install Sensu on every machine you wish to monitor. It was for this reason that Sensu was designed to be deployed by a configuration management tool, such as [Puppet](http://puppetlabs.com) or [Chef](http://chef.io); see the official [Puppet module](https://github.com/sensu/sensu-puppet) and [Chef cookbook](https://github.com/sensu/sensu-chef) for more information about how to automate your Sensu deployment.

Depending on your business requirements you may be interested in [learning more about how Sensu Works](getting-started), or in preparing Sensu for production. 

## Build a Comprehensive Telemetry Solution

Conceptually, building out a monitoring solution using Sensu requires one or more [Sensu servers](#scaling-sensu), and automating the installion of Sensu clients on all of your machines. With this core framework in place, you'll also need to define ["functional" and "informational" monitoring checks]() for all of the services in your application stack (e.g. proxy services, web services, database services, etc). Additionally, it may be prudent to collect and analyze metrics for the same services, [using Sensu as a metric router](). Finally, no comprehensive telemetry solution would be complete without configuring notification routing groups (i.e. who gets notified for what?) and defining alerting and escalation policies via Sensu Handlers. 

## Deploying Sensu into Production Environments



## Hardening Sensu



## Scaling Sensu 

- explain that there are a variety of scaling strategies (with brief overview of one or more strategies); provide link(s) to documentation page(s) on the topic(s)

