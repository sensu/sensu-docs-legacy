---
layout: "docs"
version: 1.0
weight: 2
title: "Monitoring Flow"
next:
  url: "architecture.html"
  text: "Sensu Architecture"
---

# How Sensu Works

## The Sensu Monitoring Flow

### Publishing subscription check requests

- A **Check Request** is scheduled/published by the Sensu Server or a
  **Sensu Client**
- The **Sensu Client** executes a **Service Check**
- **Service Checks** emit status information and telemetry data as **Check
  Results**
- **Check Results** are considered to be associated with either the **Sensu Client** executing the check or the **Proxy Client** of the check
- Those **Check Results** are published by the **Sensu Client** to the **Sensu Transport**, sometimes on behalf of another client
- The **Sensu Server** processes **Check Results**, persisting a copy of the
  latest result in the **Data Store** and creating a corresponding to **Event**
- The **Sensu Server** processes the **Event** by executing one or more **Event
  Handlers**
- The **Sensu Server** applies any **Event Filters** defined for an **Event
  Handler**
- The **Sensu Server** applies any **Event Data Mutators** defined for an
  **Event Handler** (assuming the event was not filtered out)
- The **Sensu Server** executes the **Event Handler** (assuming the event was
  not filtered out)

![](/docs/1.0/img/sensu-diagram.gif)
