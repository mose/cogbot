require 'open-uri'

module Cinch
  module Plugins
    class Ip
      include Cinch::Plugin

      match /ip$/

      set :plugin_name, 'ip'
      set :help, <<EOT
returns the ip grabbed from an url
EOT

      def getip()
        ip = open(@bot.config.options['cogconf']['ip']['url']).read
        ip == "Error" ? nil : ip
      rescue OpenURI::HTTPError
        nil
      end

      def new(bot)
        @bot = bot
      end

      def execute(m)
        m.reply("Server ip is " + getip())
      end

    end
  end
end
