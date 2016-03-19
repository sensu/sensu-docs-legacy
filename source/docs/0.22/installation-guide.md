---
version: 0.22
category: "Installation Guide"
title: "Installing Sensu: Overview"
next:
  url: "installation-strategies"
  text: "Installation Strategies"
---

# Installation Guide

## Objective

The purpose of this guide is to help new Sensu users get up and running with a
basic Sensu installation as quickly as possible. At the conclusion of this
guide, you &ndash; the user &ndash; should have a single server running all of
the Sensu services, their dependencies, and one or more Sensu clients.

If you are a new Sensu user &ndash; or if you have only ever used automation
tools like [Chef](https://chef.io), [Puppet](https://puppetlabs.com), or
[Ansible](https://www.ansible.com) to install and configure Sensu &ndash;
running through a manual installation for the exercise alone is _strongly
recommended_. Sensu's [architecture](/architecture) is one of its most
compelling features, and learning how Sensu's components work together will
greatly improve your ability to leverage Sensu's architecture to your advantage.

_**NOTE: manual installation is recommended for pre-production environments
only.** Please note that this guide is not intended to provide instruction for
deploying Sensu into "production" environments. Production deployment strategies
&ndash; including using automation tools like Chef, Puppet, or Ansible to
install and configure Sensu &ndash; will be discussed [at the conclusion of this
guide](installation-summary)._

### Installation overview

What will be covered in this guide:

1. [Selecting an installation strategy](installation-strategies)
  - [Standalone](installation-strategies#standalone)
  - [Distributed](installation-strategies#distributed)
  - [High Availability](installation-strategies#high-availability)
2. [How to install and configure Sensu's prerequisites](install-prerequisites)
  - [How to install and configure Redis](install-redis)
  - [How to install and configure RabbitMQ](install-rabbitmq)
3. [How to install and configure the Sensu server and API](install-sensu-server-api) (Sensu Core or Sensu Enterprise)
  - [OS-specific installation steps](install-sensu-server-api#platforms)
4. [How to install and configure a Sensu Client](install-sensu-client)
  - [OS-specific installation steps](install-sensu-client#platforms)
5. [How to install and configure a Sensu Dashboard](install-a-dashboard) (Uchiwa or Sensu Enterprise Dashboard)
  - [OS-specific installation steps](install-a-dashboard#platforms)
6. [Next steps](installation-summary)
  - [Monitoring infrastructure and applications with Sensu](installation-summary#instrumentation)
  - [Automating Sensu installation](installation-summary#automation)
  - [Hardening Sensu](installation-summary#hardening)
  - [Running Sensu at scale](installation-summary#scaling-sensu)

Upon the completion of the first five (5) steps in this guide, you &ndash; the
user &ndash; should have a fully functional Sensu installation, with one or more
Sensu clients reporting [keepalives](clients) (Sensu's built-in "heartbeat"
mechanism) back to the Sensu server, _and_ a web-based Sensu dashboard providing
visibility into the health of your infrastructure.

Once you have  a fully functional Sensu installation, you will be encouraged to
move on to the  [Getting Started Guide](getting-started-guide), which will
introduce you to  Sensu's four primary building blocks (Checks, Handlers,
Filters, and Mutators). But let's not get ahead of ourselves...

### Installation requirements

What will you need to install Sensu?

- Familiarity with a modern command-line interface & related tooling
- Compute resources (e.g. one or more virtual machines, or physical computers)
- 30-60 minutes (the amount of time it should take to complete this installation guide)
- **OPTIONAL:** A [Sensu Enterprise](/sensu-enterprise) subscription (for
  installing Sensu Enterprise).

Ready? Let's get started with selecting an installation strategy!
