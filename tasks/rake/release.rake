require 'fileutils'

def copy_with_path(src, dst)
    FileUtils.mkdir_p(dst) unless File.exists?(dst)
    FileUtils.cp_r(Dir["#{src}/*"], dst)
end

def find_and_replace(next_ver, prev_ver)
  Dir.glob("#{next_ver}/**/*.{html,md}").each do |name|
      content = File.read(name)
      content.gsub!(/version: \'#{prev_ver}'/, "version: '#{next_ver}'")
      File.open(name, "w") do |output|
       output.write(content)
      end
  end
end

desc "Bump version number"
task :bump do
  content = IO.read('_config.yml')
  content.sub!(/^current_version: (\S+)$/) {|v|
      ver = $1
      prev_ver = ver.gsub(/\'|\"/, "")
      next_ver = ver.next.gsub(/\'|\"/, "")
      copy_with_path(prev_ver, next_ver)
      find_and_replace(next_ver, prev_ver)
      "current_version: '#{next_ver}'"
  }
  puts content
  File.open('_config.yml','w') do |f|
    f.write content
  end
end


