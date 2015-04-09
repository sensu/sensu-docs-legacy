###
# Compass
###

# Susy grids in Compass
# First: gem install susy
require 'susy'

# Change Compass configuration
compass_config do |config|
  config.output_style = :compact
end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
with_layout :document do
  page "/docs"
  page "/docs/*"
end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
helpers do
  # Get Gravatar URLS
  def gravatar_url email
    require 'digest/md5'
    "http://www.gravatar.com/avatar/" +
      Digest::MD5.hexdigest(email)
  end

  # Calculate the years for a copyright
  def copyright_years(start_year)
    end_year = Date.today.year
    if start_year == end_year
      start_year.to_s
    else
      start_year.to_s + '-' + end_year.to_s
    end
  end

end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"

  # copied from https://github.com/heavywater/heavywater.github.com/blob/develop/config.rb
  activate :asset_hash
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
  activate :favicon_maker

end

###
# Custom Configs
# source: https://github.com/heavywater/heavywater.github.com/blob/develop/config.rb
###

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'img'

## Deploy to Github
activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = "master"
end

activate :syntax
set :markdown_engine, :kramdown
set :markdown, :fenced_code_blocks => true, :smartypants => true, :autolink => true,
    :quote => true, :footnotes => true

Time.zone = "America/Los_Angeles"

# activate :blog do |blog|
#   blog.prefix = "doc"
#   blog.layout = "document"
#   blog.permalink = ":title"
# end

activate :directory_indexes
activate :automatic_image_sizes
activate :livereload
