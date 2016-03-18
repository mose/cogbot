require 'open-uri'
require 'rss'

module Cinch
  module Plugins
    class Rss
      include Cinch::Plugin

      set :plugin_name, 'rss'
      set :help, <<EOT
The RSS plugin will poll rss feed every 5 minutes
EOT

      timer @bot.config.options['rss']['polling'] || 300, method: fetch_rss

      def new(bot)
        @bot = bot
        @feeds = []
      end

      def fetch_rss
        open(@bot.config.options['cogconf']['rss']['channel']) do |rss|
          feed = RSS::Parser.parse(rss)
          feed.items.reverse.each do |item|
            unless @feeds.include? item.link
              @feeds << item.link
              @feed.shift if @feed.length > 10
              @bot.config.options['cogconf']['rss']['announce'].each do |announce|
                Channel(announce).send "#{item.title} (#{item.link})"
              end
            end
          end
        end
      end

    end
  end
end
