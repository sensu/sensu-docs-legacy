desc 'Notify Google of the new sitemap'
task :sitemap do
  begin
    require 'net/http'
    require 'uri'
    puts '* Pinging Google about the sitemap'
    Net::HTTP.get('www.google.com', '/webmasters/tools/ping?sitemap=' + URI.escape('http://docs.sensuapp.org/sitemap.xml'))
  rescue LoadError
    puts '! Could not ping Google about our sitemap, because Net::HTTP or URI could not be found.'
  end
end
