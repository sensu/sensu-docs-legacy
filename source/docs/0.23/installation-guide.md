---
version: 0.23
category: "Installation Guide"
title: "Installing Sensu: Overview"
next:
  url: "installation-strategies"
  text: "Installation Strategies"
---

# Installation Guides

## The five minute install

**TL;DR**: if you just need a working Sensu installation for development or
testing purposes &mdash; you can skip the remainder of the instructions on this
page and skip to [**the five minute install**][1].

## The complete installation guide

The purpose of this guide is to help provide new and experienced Sensu users
alike with a detailed guide for installing and configuring Sensu into a variety
of operating environments. By default, this guide will direct you to install and
configure Sensu Core or Sensu Enterprise in a standalone configuration.

If you are a new Sensu user &ndash; or if you have only ever used automation
tools like [Chef][2], [Puppet][3], or [Ansible][4] to install and configure
Sensu &ndash; working through this installation guide for the exercise alone is
_strongly recommended_. Sensu's [architecture][5] is one of its most compelling
features, so learning how Sensu's components work together will greatly improve
your ability to leverage Sensu's architecture to your advantage.

_**NOTE: manual installation is recommended for pre-production environments
only.** Please note that this guide is not intended to provide instructions for
deploying Sensu into "production" environments. Production deployment strategies
&ndash; including using automation tools like Chef, Puppet, or Ansible to
install and configure Sensu &ndash; will be discussed [at the conclusion of this
guide][6]._

### Installation overview

What will be covered in this guide:

1. [Selecting an installation strategy](installation-strategies)
  - [Standalone](installation-strategies#standalone)
  - [Distributed](installation-strategies#distributed)
  - [High Availability](installation-strategies#high-availability)
2. [How to install and configure Sensu's prerequisites](install-prerequisites)
  - [How to install and configure Redis](install-redis)
  - [How to install and configure RabbitMQ](install-rabbitmq)
3. [How to install and configure the Sensu server and
   API](install-sensu-server-api) (Sensu Core or Sensu Enterprise)
4. [How to install and configure a Sensu Client](install-sensu-client)
5. [How to install and configure a Sensu Dashboard](install-a-dashboard) (Uchiwa
   or Sensu Enterprise Dashboard)
6. [Next steps](installation-summary)
  - [Monitoring infrastructure and applications with Sensu](installation-summary#instrumentation)
  - [Automating Sensu installation](installation-summary#automation)
  - [Hardening Sensu](installation-summary#hardening)
  - [Running Sensu at scale](installation-summary#scaling-sensu)

Upon the completion of the first five (5) steps in this guide, you &ndash; the
user &ndash; should have a fully functional Sensu installation, with one or more
Sensu clients reporting [keepalives][7] (Sensu's built-in "heartbeat" mechanism)
back to the Sensu server, _and_ a web-based Sensu dashboard providing visibility
into the health of your infrastructure.

Once you have  a fully functional Sensu installation, you will be encouraged to
move on to the  [Getting Started Guide][8], which will introduce you to  Sensu's
four primary building blocks (Checks, Handlers, Filters, and Mutators). But
let's not get ahead of ourselves...

### Installation requirements

What will you need to install Sensu?

- Familiarity with a modern command-line interface & related tooling
- Compute resources (e.g. one or more virtual machines, or physical computers)
- 30-60 minutes (the amount of time it should take to complete this installation guide)
- **OPTIONAL:** A [Sensu Enterprise][9] subscription (for
  installing Sensu Enterprise).

Ready? Let's get started with selecting an installation strategy!

[1]:  the-five-minute-install
[2]:  https://chef.io
[3]:  https://puppetlabs.com
[4]:  https://www.ansible.com
[5]:  architecture
[6]:  installation-summary
[7]:  clients#client-keepalives
[8]:  getting-started-guide
[9]:  https://sensuapp.org/sensu-enterprise
