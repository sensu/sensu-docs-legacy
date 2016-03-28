---
version: 0.22
category: "Getting Started Guide"
title: "Getting Started with Sensu"
next:
  url: "getting-started-with-checks"
  text: "Getting Started with Checks"
---

# Getting Started with Sensu

## Learn Sensu in 15 minutes or less

**TL;DR**: if you are looking for a quick & high-level overview of how Sensu
works &mdash; you can skip the remainder of this guide and jump to [**the quick
start guide**](learn-sensu-in-15m).

## The complete getting started guide

The purpose of this guide is to help new Sensu users to obtain a basic
understanding of the primitives or components used to build a comprehensive
monitoring solution. In the course of working through this guide, users should
be able to start monitoring servers, services, and application health, collect
and analyze metrics, and setup alerts.

## Objectives

This guide will provide an introduction to the following primitives, and
built-in features (for Sensu Enterprise users):

- Checks - used to monitor services or measure resources
- Handlers - for taking action on Sensu events, which are produced by checks
- Filters - for filtering (removing) events destined for one or more event handlers
- Mutators - transform event data for handlers


## WIP:

- Familiarity with [standard streams][wiki-streams] (i.e. `stdin`, `stdout`,
  and `stderr`)

[wiki-cli]:       https://en.wikipedia.org/wiki/Command-line_interface
[wiki-streams]:   https://en.wikipedia.org/wiki/Standard_streams
