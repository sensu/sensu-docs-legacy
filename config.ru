require 'rack/contrib/static_cache'
require 'rack/contrib/try_static'
require 'rack/contrib/not_found'
require 'rack/rewrite'

use Rack::Deflater

use Rack::StaticCache,
    :urls => %w[/css /js /ico /img /favicon.ico],
    :root => "_site"

use Rack::TryStatic,
    :urls => %w[/],
    :root => "_site",
    :try  => ['.html', 'index.html', '/index.html']

run lambda { [404, {'Content-Type' => 'text/html'}, ['Not Found']]}
