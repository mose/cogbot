require 'open-uri'
require 'nokogiri'
require 'cgi'

module Cinch
  module Plugins
    class Google
      include Cinch::Plugin

      match /g (.+)/

      set :plugin_name, 'google'
      set :help, <<EOT
Google returns the first google match on a search
.g  <keywords> : searches on those keywords
EOT

      def new(bot)
        @bot = bot
      end

      def search(query)
        url = "http://www.google.com/search?q=#{CGI.escape(query)}"
        res = Nokogiri::HTML(open(url)).at("h3.r")

        title = res.text
        link = res.at('a')[:href]
        link.gsub!(/^.*q=(.*)&sa.*$/) { $1 }
        CGI.unescape_html "#{title} (#{link})"
      rescue
        "No results found"
      end

      def execute(m, query)
        m.reply(search(query))
      end
    end
  end
end
