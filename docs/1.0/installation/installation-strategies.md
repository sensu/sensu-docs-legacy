---
title: "Installation Strategies"
description: "The complete Sensu installation guide."
version: 1.0
weight: 2
next:
  url: "installation-prerequisites.html"
  text: "Installation Prerequisites"
---

# Installation strategies

Sensu's [architecture][1] is one of its most compelling features. It
is flexible enough to be installed on a single system for
development/testing/lab purposes (or small production environments), and
sophisticated enough to support highly available configurations capable of
monitoring <abbr title='numbering into the tens of thousands of
servers'>infrastructure at scale</abbr>.

Please review the following definitions of standalone, distributed, and
high-availability installation strategies to help you select which one will be
the most appropriate for your installation. If you're just getting started with
Sensu and/or if you're not sure which strategy to choose, follow the
instructions for a **standalone** installation.

## Standalone {#standalone}

**Install all of Sensu's dependencies and services on a single system.** For the
purposes of this installation guide (which is designed to help new users learn
how Sensu works and/or setup Sensu in a development environment), a standalone
installation is recommended.

To proceed with a standalone installation, please select a single compute
resource with a **minimum of 2GB of memory (4GB recommended)** (e.g. a physical
computer, virtual machine, or container) as your installation target, and
[continue to the next step in the guide][2].

_NOTE: Sensu's modular design makes it easy to upgrade from a standalone
installation to a distributed or high-availability installation, so unless you
have some specific technical requirement that demands a distributed or high
availability installation, there's usually no need to start with a more complex
installation._

## Distributed {#distributed}

**Install Sensu's dependencies (e.g. RabbitMQ and/or Redis) and services (i.e.
the Sensu server and API) on separate systems.** The only difference between
a Standalone installation and a Distributed installation is that Sensu's
dependencies and services are running on different systems. As a result,
although this guide will explain how to perform a Distributed Sensu
installation, it will not cover such industry-standard concepts as networking,
etc (i.e. configuring services to communicate with other services installed
elsewhere on the network will be left as an exercise for the user; e.g.
replacing default `localhost` configurations with the corresponding addresses
and/or ports, and ensuring that the appropriate network connections and firewall
rules will allow said services to communicate with one another).

To proceed with a distributed installation, please select a minimum of two (2)
compute resources (e.g. physical computers, virtual machines, or containers) as
your installation targets, and [continue to the next step in the
guide][2].

_NOTE: for the purposes of this installation guide, distributed installation
will be described in terms of two (2) installation targets. One system will act
as the "transport and datastore" system, and one system will be act as the
Sensu server. Advanced users who may wish to use more than two systems are
welcome to do so (e.g. using one as the transport/RabbitMQ, one as the
data store/Redis, one as the Sensu server, and one or more for running Sensu
clients)._

## High Availability {#high-availability}

**Install Sensu's dependencies across multiple systems, in a high-availability
configuration (clustering, etc), _and_ install the Sensu services on multiple
systems in a clustered configuration.** High availability configurations will be
introduced at [conclusion of this guide][3].

[1]:  ../overview/architecture.html
[2]:  installation-prerequisites.html
[3]:  summary.html
