---
version: 0.17
category: "Getting Started Guide"
title: "Getting Started with Sensu"
next:
  url: "getting-started-with-checks"
  text: "Getting Started w/ Checks"
---

# Introduction

The purpose of this guide is to help new Sensu users to obtain a basic understanding of the primitives or components used to build a comprehensive monitoring solution. In the course of working through this guide, users should be able to start monitoring servers, services, and application health, collect and analyze metrics, and setup alerts.

## Objectives

This guide will provide an introduction to the following primitives, and built-in features (for Sensu Enterprise users):

- Checks - used to monitor services or measure resources
- Handlers - for taking action on Sensu events, which are produced by checks
- Filters - for filtering (removing) events destined for one or more event handlers
- Mutators - transform event data for handlers
