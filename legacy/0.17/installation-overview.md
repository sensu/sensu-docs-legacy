---
version: 0.17
category: "Installation Guide"
title: "Installing Sensu: Overview"
next:
  url: "install-rabbitmq"
  text: "Install RabbitMQ"
---

# Introduction

The purpose of this guide is to help new Sensu users get up and running with a basic Sensu installation. At the conclusion of this guide, you - the user - should have a single server running all of the Sensu services, their dependencies, and a running Sensu client; optionally, this guide also provides instructions for getting Sensu client installed and running on one or more remote machines. Please note that this guide is not intended to provide instruction for deploying Sensu into "production" environments. However, production deployment strategies will be discussed at the conclusion of the guide.

## Objectives

What will be covered in this guide:

- Installation and configuration of Sensu's dependencies (RabbitMQ & Redis)
- Installation and configuration of the Sensu Core or Sensu Enterprise services
- Installation and configuration of Sensu client(s)
- Installation and configuration of a Sensu dashboard
- Next steps; e.g. production deployment strategies
