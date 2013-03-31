$LOAD_PATH << File.join(File.dirname(__FILE__), 'tasks')

require 'rubygems'
require 'fileutils'

Dir['tasks/**/*.rake'].each { |t| load t }

LINK = "http://docs.sensuapp.org"
ROOT_DIR = File.dirname(__FILE__)
SITE_DIR = File.join(ROOT_DIR, '_site')
DRAFTS_DIR = File.join(ROOT_DIR, '_drafts')
POSTS_DIR = File.join(ROOT_DIR, '_posts')

task :default => :build

desc "Bump version number"
task :bump do
  content = IO.read('_config.yml')
  content.sub!(/^current_version: (\S+)$/) {|v|
      ver = $1.next
      Dir.mkdir(ver) unless File.exists?(ver)
      "current_version: #{ver}"
  }
  File.open('_config.yml','w') do |f|
    f.write content
  end
end

desc "Clear generated site."
task :clean do
    rm_rf Dir.glob(File.join(SITE_DIR, '*'))
end

desc "Generate site."
task :build do
  sh "jekyll --time \"#{Time.now}\""
end

desc "Run local jekyll server"
task :server, [:port] => [ :build ] do |t, args|
    sh "jekyll --server #{args.port || 4000} --auto --time \"#{Time.now}\""
end

desc "Rsync site"
task :deploy => [ :build ] do
  # deploy system
  Rake::Task['sitemap'].invoke
  puts "Site deployed"
  puts ""
end
