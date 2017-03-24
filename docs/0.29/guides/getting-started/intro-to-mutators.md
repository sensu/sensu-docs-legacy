---
title: "Intro to Mutators"
version: 0.29
weight: 6
---

# Getting Started with Mutators

The purpose of this guide is to help Sensu users create event data mutators. At
the conclusion of this guide, you - the user - should have several Sensu
mutators in place to mutate (transform) event data for one or more event
handlers. Each Sensu mutator in this guide demonstrates one or more mutator
definition features, for more information please refer to the [Sensu mutators
reference documentation][1].

### Objectives

What will be covered in this guide:

- What are Sensu mutators?
- Creation of a Sensu event data mutator

## What are Sensu mutators? {#what-are-sensu-mutators}

Sensu mutators mutate (transform) event data for a Sensu event handler. Sensu
event handlers can expect event data be in a different format and/or
manipulated. Mutators allow one or more handlers to share logic, reducing code
duplication, and simplifying the event handlers. Sensu mutators are executed on
machines running the Sensu server or Sensu Enterprise. Mutators are essentially
commands (or scripts) that receive JSON formatted event data via `STDIN` and
output the mutated event data to `STDOUT`. Mutators use an exit status code of
`0` to indicate a success, anything else indicates a failure. If a mutator fails
to execute (non-zero exit status code), the event will not be handled, and an
error will be logged.

## Create an event data mutator

Coming soon. Please see the [Mutators][1] reference documentation. If you have
questions about event data mutators, please contact [Sensu Support][2].


[1]:  ../reference/mutators.html
[2]:  http://helpdesk.sensuapp.com
