---
title: "Extensions"
description: "Reference documentation for Sensu Extensions."
version: 0.28
weight: 10
---

# Sensu Extensions

## Reference documentation

- [What is a Sensu extension?](#what-is-a-sensu-extension)
- [Installing Sensu extensions](#installing-sensu-extensions)
- [Installing Sensu legacy extensions](#installing-sensu-legacy-extensions)
- [Configuring Sensu extensions](#configuring-sensu-extensions)
- [The Sensu Extension gem](#the-sensu-extension-gem)
- [The Sensu Extensions gem template](#the-sensu-extensions-gem-template)

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

### Installing Sensu extensions

As of version 0.28, Sensu supports loading extensions from properly packaged
gems. This approach takes advantage of the existing RubyGems infrastructure and
tools to make publishing and installing Sensu extensions easy.

Sensu extensions can be installed using the `sensu-install` executable:

#### EXAMPLE {#installing-sensu-extensions-from-gems-example}

~~~ shell
sensu-install -e sensu-extensions-system-profile
~~~

### Configuring Sensu to load extensions

Once an extension is installed via gem, Sensu must be explicitly configured to
load the extension. This is accomplished by providing
configuration under the top level `extensions` attribute:

#### EXAMPLE {#configuring-extension-loading-from-gems-example}

~~~ json
{
  "extensions": {
    "system-profile": {
      "gem": "sensu-extensions-system-profile"
    }
  }
}
~~~

#### EXAMPLE {#configuring-extension-loading-from-gems-w-version-example}

Configuration may optionally include a version specification:

~~~ json
{
  "extensions": {
    "system_profile": {
      "gem": "sensu-extensions-system-profile",
      "version": "1.0.0"
    }
  }
}
~~~

Once extensions have been explicitly enabled in Sensu's configuration, they will
be loaded the next time Sensu processes are restarted. Informational messages
are printed to the log when extensions are loaded:

#### EXAMPLE {#configuring-extension-loading-from-gems-log-example}

~~~
{"timestamp":"2016-08-08T16:37:25.711275+0000","level":"warn","message":"loading
extension gem","gem":"sensu-extensions-system-profile","version":"1.0.0"}
{"timestamp":"2016-08-08T16:37:25.711419+0000","level":"warn","message":"requiring
extension gem","require":"sensu/extensions/system-profile"}
{"timestamp":"2016-08-08T16:37:25.711579+0000","level":"warn","message":"loaded
extension","type":"check","name":"system_profile","description":"collects system
metrics, using the graphite plain-text format"}
~~~


_NOTE: Explicit extension loading does not apply to [legacy
extensions](#installing-sensu-legacy-extensions), which are loaded by virtue of
being placed in the extension directory._

## Installing Sensu legacy extensions

Sensu extensions which are not properly packaged as gems are considered
"legacy", meaning they predate the new specification for loading Sensu
Extensions from gems.

These legacy extensions are loaded from the directory specified by the
`--extension_dir` flag provided [when Sensu processes are started][8].  On most
systems this defaults to `/etc/sensu/extensions`, as specified by the command
flags passed to the sensu-client or sensu-server process via the service
supervision scheme in use (e.g. init, runit, upstart, systemd, etc).
Extensions should be installed directly into the extensions directory.

When an legacy extension has dependencies on third-party Ruby gems or other external
applications, those dependencies must be installed into the Sensu embedded Ruby
environment as well.

### Configuring Sensu Extensions

The configurability of Sensu extensions is entirely a function of the extension code.
For example, filters and mutators cannot be applied to an extension via a standard
handler definition. Instead, these aspects of the extension's configuration must be
defined in code by overriding the [Sensu::Extension::Base `definition` method][10]:

#### EXAMPLE {#extension-configuration-in-code-example}

~~~ ruby
def definition
  {
    :type => "extension",
    :name => name,
    :filters => ["occurrences"],
    :mutator => "only_check_output"
  }
end
~~~

The above code would configure the associated extension to apply the
`occurrences` filter, and then the `only_check_output` mutator, prior to
executing the extension's custom `run` method.

By virtue of being loaded into the Sensu client or server process, Sensu
extensions have access to the running Sensu configuration. As such an extension
can make use of any available [configuration scopes][9], but the prevailing
convention is for extensions to use unique top-level configuration scopes.

The [`system_profile`][4] extension installed in a previous example looks to the
top-level `system_profile` configuration scope. The following configuration
added to `/etc/sensu/conf.d` would change the `system_profile` extension's
Graphite path prefix from a default value of "system" to "profile":

#### EXAMPLE {#providing-extension-configuration-example}

~~~ json
{
  "system_profile": {
    "path_prefix": "profile"
  }
}
~~~

## The sensu-extension gem

Unlike Sensu plugins, which may be written in any programming language, Sensu
extensions must be written in Ruby. The [sensu-extension][5] gem provides
`Sensu::Extension::Base` and other classes which Sensu extensions should
subclass.

## The sensu-extensions gem template

The [sensu-extensions gem template][12] provides a starting point for those who wish
to author their own Sensu extension as a Ruby gem. It is recommended that your
gem follow the naming pattern "sensu-extension-$NAME" in order to ensure it can
be easily installed with `sensu-install`.

_NOTE: if you choose not to use this template for your extension, note the
directory structure it demonstrates  (e.g. placing extension code under
`lib/sensu/extensions/`) are required to ensure the extension is properly loaded._

## Example extensions

For simple examples of Sensu extensions, consider the [`only_check_output`
mutator][6] or the [`debug` handler][7]), both of which ship with Sensu.

You can find other Sensu extensions, some of which are packaged in the Sensu
Core distribution, by [searching RubyGems][11].

[1]: https://github.com/eventmachine/eventmachine/wiki/General-Introduction
[2]: http://javieracero.com/blog/starting-with-eventmachine-iv
[4]: https://rubygems.org/gems/sensu-extensions-system-profile
[5]: https://github.com/sensu/sensu-extension
[6]: https://github.com/sensu-extensions/sensu-extensions-only-check-output/blob/master/lib/sensu/extensions/only-check-output.rb
[7]: https://github.com/sensu-extensions/sensu-extensions-debug/blob/master/lib/sensu/extensions/debug.rb
[8]: configuration.html#sensu-service-init-configuration
[9]: configuration.html#configuration-scopes
[10]: https://github.com/sensu/sensu-extension/blob/v1.5.0/lib/sensu/extension.rb#L42-L50
[11]: https://rubygems.org/search?utf8=%E2%9C%93&query=sensu-extensions-
[12]: https://github.com/sensu-extensions/template
