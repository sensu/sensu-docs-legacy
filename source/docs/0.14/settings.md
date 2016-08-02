---
version: "0.14"
category: "Settings"
title: "Settings"
published: false
---

# Sensu settings {#sensu-settings}

Sensu extensions and handlers often need to access the sensu configuration
data in order to properly operate. This settings data is available to both
extensions and handlers as a large hash.

## Extension Examples

Extensions operate inside the same Ruby process as the Sensu Server, they
should access settings via the @settings instance variable:

```ruby
# Local method to get settings for the extension if available
def options
  return @options if @options
  @options = {
    :host    => '127.0.0.1',
    :port    => 6379,
    :channel => 'events',
    :db      => 0
  }
  if @settings[:flapjack].is_a?(Hash)
    @options.merge!(@settings[:flapjack])
  end
  @options
end
```

## Handler Examples

Handlers can extract any piece of configuration data they need to operate. 
Handlers can use the settings method from sensu-plugin. 

Usually a handler's configuration will be a "top-level" hash with the same name
as the handler itself:

```ruby
delivery_method = settings['mailer']['delivery_method'] || 'smtp'
smtp_address = settings['mailer']['smtp_address'] || 'localhost'
smtp_port = settings['mailer']['smtp_port'] || '25'
smtp_domain = settings['mailer']['smtp_domain'] || 'localhost.localdomain'
```

## See also

* [sensu-settings](https://rubygems.org/gems/sensu-settings) a helping rubygem
used by the server to load and validate the JSON to build the settings hash.
* [sensu-plugin](https://github.com/sensu/sensu-plugin#handlers) is a rubygem
used for building handlers, which also provides a `settings` dictionary.

