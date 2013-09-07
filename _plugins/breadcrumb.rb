# usage:
# {% breadcrumb <directory:dir_name> %}
# 
# This will output a Twitter Bootstrap formatted breadcrumb structure. 
# See http://twitter.github.com/bootstrap/components.html#breadcrumbs
# for more details.
#
# The directory argument specifies a directory name that, when encountered, 
# ends the backtracking of the dir up the tree. If directory isn't 
# specified, it will continue moving up to the root of the current pages dir.

module Jekyll
    # Add accessor for directory
    # this lets us get the full path to the page
    class Page
        attr_reader :dir
    end

    class BreadCrumbTag < Liquid::Tag

        include Liquid::StandardFilters
        Syntax = /(#{Liquid::QuotedFragment}+)?/

        def initialize(tag_name, markup, tokens)
            @attributes = {}
            @attributes['directory'] = '';

            # Parse parameters
            if markup =~ Syntax
                markup.scan(Liquid::TagAttributes) do |key, value|
                    @attributes[key] = value
                end
            else
                raise SyntaxError.new("Bad options given to 'breadcrumb' plugin.")
            end

            super
        end

        def get_current_page(context)
            purl = context.environments.first["page"]["url"]
            context.registers[:site].pages.each do |p|
              if p.url == purl
                return p
              end
            end
            return nil
        end

        def find_match(search,context)
            context.registers[:site].pages.each do |p|
              if p.url.match(search)
                return p
              end
            end
            return nil
        end

        def render(context)
            context.registers[:breadcrumb] ||= Hash.new(0)

            page = get_current_page(context)
            if !page
              puts "Failed to get current page"
              return ''
            end

            begin
              title = page.data['title']
            rescue
              title = page.name
            end

            # The dir we split on doesn't contain the file name, so 
            # we push a dummy entry on at the end before we reverse. 
            # This will be ignored since we always use the page object
            # instead of the array entry for the first hit
            oparts = page.dir.split("/")
            oparts.push("dummy!") 
            oparts.reverse!

            # search up through the dir path to find the first
            # directory that matches the specified attribute.
            # If no attr was specified, this is skipped and the 
            # entire path is used.
            last = oparts.size - 1
            if @attributes['directory'] != "/"
              oparts.each_with_index do |part,index|
                if part == @attributes['directory']
                  last = index
                  break
                end
              end
            end

            res = []
            oparts.each_with_index do |part,index|
              if part == "" || index > last
                break
              end
              if index == 0
                res.push("<li class=\"active\">#{title}</li>")
              else
                begin
                  part_num = part.split("_",1)[0]
                rescue
                  part_num = ""
                end
                parent = oparts[(index+1)..-1].reverse.join("/")
                search = "#{parent}/#{part_num}_-_.*\.html"
                target = find_match(search,context)
                if !target
                  link = parent+"/"+part
                else
                  begin
                    link = target.url
                  rescue
                  end
                end
                res.push("<li><a href=\"#{link}\">#{part}</a> <span class=\"divider\">/</span></li>")
              end
            end

            html = '<ul class="breadcrumb">'
            html += "<li><a href='/'>Home</a> <span class=\"divider\">/</span></li>"
            html += res.reverse.join("")
            html += '</ul>'
        end
    end
end

Liquid::Template.register_tag('breadcrumb', Jekyll::BreadCrumbTag)
