---
version: "0.16"
category: "Configuration"
title: "Extensions"
---

# Sensu extensions {#sensu-extensions}

Extending Sensu is particularly useful in high-volume installations where you
are running checks, mutating, or handling a large amount of your traffic in a
particular way.  Rather than forking for each event, extensions run inside the
main EventMachine loop for Sensu. This should be kept in mind when developing
extensions for Sensu as you have the "opportunity" to interrupt the event loop
which can cause instability and performance degradation.

Sensu currently supports extensions for checks, mutators, and handlers. Mutator
and handler extensions, like standard mutator and handler plug-ins, run inside
the sensu-server process. Check extensions run on client machines within the
sensu-client process. Your extensions will live within the Sensu::Extension
module and will sub-class one of the support extension classes: Handler,
Mutator, or Check.

## Skeleton Extension {#skeleton-extension}

~~~ ruby

module Sensu::Extension

  class Skeleton < Handler # Sub-class the appropriate extension type

    # The post_init hook is called after the main event loop has started
    # At this time EventMachine is available for interaction.
    def post_init
    end

    # Must at a minimum define type and name. These are used by
    # Sensu during extension initialization.
    def definition
      {
        type: 'extension',  # Always.
        name: 'skeleton',   # Usually just class name lower case.
        mutator: 'amutator' # OPTIONAL
      }
    end

    # Simple accessor for the extension's name. You could put a different
    # value here that is slightly more descriptive, or you could simply
    # refer to the definition name.
    def name
      definition[:name]
    end

    # A simple, brief description of the extension's function.
    def description
      'Minimal skeleton extension'
    end

    # run() is passed a copy of the event_data hash
    # for more information, see links below.
    def run(event_data)
      # You need to yield to the caller. The first argument should be the
      # data you want to yield (in the case of handlers, nothing or an error
      # string, and the return status of the extension.
      yield("", 0)
    end

    # Called when Sensu begins to shutdown.
    def stop
      true
    end

  end
end
~~~

Event data is passed to extensions just like plug-ins.
See:

[Events](event_data)

The settings hash is passed to the extension as instance data (in the @settings
instance variable).

[Settings](settings)

## Handler Extensions {#handler-extensions}

Handler extensions are useful in firehose situations. Let's assume that you have
some portion of your traffic that you wish to relay to another location. You
could easily write a handler plug-in to do this, but an extension would be
significantly less resource intensive. Were a simple firehose implemented in
a plug-in, every event would cause a fork of the parent ruby process and
writing data over a TCP (more likely) or UDP connection.

An extension, on the other hand, could maintain persistent TCP connections
to the firehose destination and simply write serialized event data over that
connection.

## Mutator Extensions {#mutator-extensions}

Mutator extensions are particularly helpful if you need to mutate a large number
of events. For example, if your organization was previously storing metrics
in Graphite and wanted to move all metrics to OpenTSDB without re-writing all
of your metrics-gathering code first, you could write a mutator extension to
transform your metrics inline and submit them to OpenTSDB via a handler.

This particular example ties together another bit of information about
extensions. Handler extensions can be tied together with mutator extensions by
specifying the mutator you want to use in tandem with your handler. In the
skeleton framework above we created a handler extension and tied it to the
'amutator' extensions.

In this case, you have a great deal more flexibility with what happens to the
event\_data. For example, you could yield a wholly different data structure
to your handler to facilitate the implementation of some more complex
functionality. If, on the other hand, you want to be a passive mutator and
simply modify some class of events, you want to ensure that event\_data leaves
your mutator in a similar composition.

As with all mutators, your mutator extension cannot be chained to existing
mutators.

## Check Extensions {#check-extensions}

Check extensions are useful in situations where persistent resources are required by a check. Instance variables in check extensions are persistent since the extension's class is instantiated when the client starts and persists until the client stops, allowing checks with persistent data structures and properties. Check extensions inherit the class ```Sensu::Extension::Check```.

As an example, if you needed to poll a gauge such as system CPU utilization in the last second and average that over the check's run interval to produce a metric, you could create a timer that would check the current CPU utilization periodically in your extension's ```post_init()``` method. Then, the ```run()``` method of the check extension could average these data points and return it as a metric representing average CPU utilization over some time period.

The hash returned by the ```definition()``` method in the check extension defines when and how the extension should be executed, as well as the other check parameters that should be passed through as event data. This hash can include any of the check configuration options normally accepted by checks, such as ```interval```, ```refresh```, ```type```, ```handlers```, and so on. 

Unlike plugin checks, check extensions inheriting from ```Sensu::Extension::Check``` return output via the ```yield``` method. The convenience methods ```ok```, ```warning```, ```critical```, and ```unknown``` are not available. This ```yield``` call takes a string to be output as the first argument and an exit code as the second. The exit code supplied to ```yield``` maps to the exit codes used by plugin checks: 0 for OK, 1 for WARNING, 2 for CRITICAL, and 3 for UNKNOWN. For example, to return the string "Everything looks okay!" as the check's output and a zero exit code indicating that the check's status is OK, you could call the following from the ```run()``` method:

```yield "Everything is okay!", 0```
