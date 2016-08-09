---
title: "Extensions"
description: "Reference documentation for Sensu Extensions."
version: 0.25
weight: 10
---

# Sensu Extensions

## Reference documentation

- [What is a Sensu extension?](#what-is-a-sensu-extension)
- [Installing Sensu extensions](#installing-sensu-extensions)
  - [Installing extension dependencies](#installing-extension-dependencies)
  - [Installing Sensu extensions from gems](#install-sensu-extensions-from-gems)
- [Configuring Sensu extensions](#configuring-sensu-extensions)
- [The Sensu Extension gem](#the-sensu-extension-gem)
- [The Sensu Extensions gem](#the-sensu-extensions-gem)

## What is a Sensu extension?

Unlike Sensu plugins, which spawn a new child process at every execution, Sensu
extensions execute directly inside the [EventMachine reactor thread][1] of a
Sensu client or server process. Because they avoid the overhead of spawning a
new process at every invocation, Sensu extensions can fulfill the same functions
as plugins, acting as checks, filters, mutators or handlers, but with much
greater efficiency.

_WARNING: While their performance characteristics are quite desirable, Sensu
extensions come with major caveats: extensions have full access to Sensu's
internals, and **any extension which blocks the EventMachine reactor for any
period of time (e.g. blocking on disk IO or network request) will have a very
significant negative impact on Sensu's performance and functionality.** The
details of evented programming as implemented by EventMachine are outside the
scope of this document, but Javier Acero has helpfully [written on the
implications of blocking the reactor][2]._

## Installing Sensu extensions

Sensu extensions are loaded from the directory specified by the
`--extension_dir` flag provided [when Sensu processes are started][8].  On most
systems this defaults to `/etc/sensu/extensions`, as specified by the command
flags passed to the sensu-client or sensu-server process via whatever service
supervision scheme is in use (e.g. init, runit, upstart, systemd, etc).
Extensions should be installed directly into the extensions directory.

### Installing extension dependencies

When an extension has dependencies on third-party Ruby gems or other external
applications, those dependencies must be installed into the Sensu embedded Ruby
environment as well.

### Installing Sensu extensions from gems

At present a handful of extensions (e.g. [sensu-extension-snmptrap][3]) are
available as gems packages. The Sensu extension loader implementation does
not support loading extensions directly from gems. As a result, gems which
provide an extension may be installed into the Sensu embedded Ruby environment
(e.g. using `gem` or `sensu-install` commands), but an additional step is
required to symlink the actual extension code into the `extension_dir`
directory.

#### EXAMPLE {#installing-sensu-extensions-from-gems-example}

~~~ shell
sensu-install -p sensu-plugins-snmptrap-extension

ln -s /opt/sensu/embedded/lib/ruby/gems/*/gems/sensu-plugins-snmptrap-extension-*/bin/extension-snmptrap.rb /etc/sensu/extensions/extension-snmptrap.rb
~~~

## Configuring Sensu extensions

The configurability of Sensu extensions is entirely a function of the extension code.
For example, filters and mutators cannot be applied to an extension via a standard
handler definition. Instead, these aspects of the extension's configuration must be
defined in code by overriding the [Sensu::Extension::Base `definition` method][10]:

~~~ ruby
def definition
  {
    :type => "extension",
    :name => name,
    :filters => ["my_custom_filter"],
    :mutator => "only_check_output"
  }
end
~~~

The above code would configure the associated extension to apply the `only_check_output` mutator
and the `my_custom_filter` filter before executing the extension's custom `run` method.

By virtue of being loaded into the Sensu client or server process, Sensu
extensions have access to the running Sensu configuration. As such an extension
can make use of any available [configuration scopes][9], but the prevailing
convention is for extensions to use unique top-level configuration scopes.

For example, the [`system_profile`][4] extension looks to the top-level
`system_profile` configuration scope. The following configuration added to
`/etc/sensu/conf.d` would change the `system_profile` extension's Graphite path
prefix from a default value of "system" to "profile":

~~~ json
{
  "system_profile": {
    "path_prefix": "profile"
  }
}
~~~

## The sensu-extension gem

Unlike Sensu plugins, which may be written in any programming language, Sensu
extensions must be written in Ruby. To make writing extensions more convenient,
the [sensu-extension][5] gem provides the `Sensu::Extension::Base` class which
Sensu extensions should subclass in order to implement their custom
functionality.

## The sensu-extensions gem

The [sensu-extetensions gem](https://github.com/sensu/sensu-extensions) provides
both Sensu's internal mechanism for loading extensions, and a number of built-in
extensions (e.g. `only_check_output` and `debug` extensions linked above).

## Examples

For simple examples of Sensu extensions, consider the [`only_check_output`
mutator][6] or the [`debug` handler][7]), both of which ship with Sensu.

[1]: https://github.com/eventmachine/eventmachine/wiki/General-Introduction
[2]: http://javieracero.com/blog/starting-with-eventmachine-iv
[3]: https://github.com/warmfusion/sensu-extension-snmptrap
[4]: https://github.com/sensu/sensu-core-extensions/blob/master/checks/system_profile.rb
[5]: https://github.com/sensu/sensu-extension
[6]: https://github.com/sensu/sensu-extensions/blob/v1.5.0/lib/sensu/extensions/mutators/only_check_output.rb
[7]: https://github.com/sensu/sensu-extensions/blob/v1.5.0/lib/sensu/extensions/handlers/debug.rb
[8]: configuration.html#sensu-service-init-configuration
[9]: configuration.html#configuration-scopes
[10]: https://github.com/sensu/sensu-extension/blob/v1.5.0/lib/sensu/extension.rb#L42-L50