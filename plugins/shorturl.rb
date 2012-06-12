require 'open-uri'

module Cinch
  module Plugins
    class Shorturl
      include Cinch::Plugin

      match /(http:\/\/[^ ]*)/, :use_prefix => false

      set :plugin_name, 'shorturl'
      set :help, <<EOT
Shorturl catches urls said on channel and shorten then
EOT

      def shorten(url)
        url = open("http://tinyurl.com/api-create.php?url=#{URI.escape(url)}").read
        url == "Error" ? nil : url
      rescue OpenURI::HTTPError
        nil
      end

      def new(bot)
        @bot = bot
      end

      def execute(m,url)
        m.reply("Shortening: " + shorten(url))
      end

    end
  end
end
