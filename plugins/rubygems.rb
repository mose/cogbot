require 'open-uri'
require 'yajl'
require 'cgi'

module Cinch
  module Plugins
    class Rubygems
      include Cinch::Plugin

      match /r (.*)$/

      set :plugin_name, 'rubygems'
      set :help, <<EOT
Rubygems queries http://rubygems.org for finding gems
EOT

      def query(query)
        url = "https://rubygems.org/api/v1/search.json?query=#{CGI.escape(query)}"
        back = "Requesting ... \n"
        begin
          file = open(url)
          if file.class == StringIO
            json = Yajl::Parser.parse(file)
            if json.empty?
              return "Nothing matches '#{query}'"
            end
          else
            json = Yajl::Parser.parse(File.read(file))
          end
          all = json.count > 4 ? 4 : json.count
          all.times do |it|
            back += "#{json[it]['name']} : #{json[it]['homepage_uri']}\n"
          end
        rescue Exception => e
          p file.class
          back = "*** #{e.class}\n"
          back += e.backtrace.join("\n")
          back += e.to_s
        end
        return back
      end

      def new(bot)
        @bot = bot
      end

      def execute(m,words)
        m.reply(query(words.strip))
      end

    end
  end
end
