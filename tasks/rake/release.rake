

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


