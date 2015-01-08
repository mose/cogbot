require 'open-uri'
require 'nokogiri'
require 'cgi'

module Cinch
  module Plugins
    class Urban
      include Cinch::Plugin

      match /u (.*)$/

      set :plugin_name, 'urban'
      set :help, <<EOT
Urban connects to urban dictionary and returns the first result for a given query, replying with the result directly to the sender
EOT

      def query(query)
        url = "http://www.urbandictionary.com/define.php?term=#{CGI.escape(query)}"
        begin
          CGI.unescape_html Nokogiri::HTML(open(url)).at("div.meaning").text.gsub(/\s+/, ' ')
        rescue
          "no result found"
        end
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
