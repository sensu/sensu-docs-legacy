---
layout: default
title: Community
description: Sensu community projects
version: '0.11'
---

## Configuration Management
* [Chef Cookbook](https://github.com/sensu/sensu-chef)

  - The official Sensu Cookbook.  It is meant to be used with a [wrapper cookbook](https://github.com/portertech/chef-monitor).

* [Chef-monitor](https://github.com/portertech/chef-monitor)

  - A wrapper cookbook to work in conjunction with the Chef cookbook.

* [Puppet](https://github.com/sensu/sensu-puppet)

  - The official Sensu Puppet module.

* [SensuCleaner](https://github.com/SimpleFinance/chef-handler-sensu)

  - A Chef handler to cleanup stale Sensu checks by cross-checking the files in your checks directory with the resources from the Chef run.

## Plugins, Handlers and extensions

* [Community plugins](https://github.com/sensu/sensu-community-plugins)

  - The official community plugins bundle. This gem contains some example plugins and handlers for Sensu. Most of them are implemented in Ruby and use the sensu-plugin framework (a small gem); some also depend on additional gems (e.g. mysql). Some are shell scripts! All languages are welcome.

## Other Projects

* [Sensu-cli](https://github.com/agent462/sensu-cli)

  - A sensu-cli for interacting with the sensu API.  Full API coverage which means you can resolve events, silence checks, delete clients and all other api functions.

* [Sensu-Admin](https://github.com/sensu/sensu-admin)

  - An alternative sensu dashboard with additional functionality like scheduling downtime.

* [Hubot](https://github.com/sensu/sensu-hubot)

  - A hubot script for interactive with Sensu.
