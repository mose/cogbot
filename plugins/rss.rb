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

      timer 300, method: :fetch_rss

      def new(bot)
        @bot = bot
        @feeds = []
      end

      def fetch_rss
        @feeds ||= []
        open(@bot.config.options['cogconf']['rss']['channel']) do |rss|
          feed = RSS::Parser.parse(rss)
          p @feeds.length
          p feed.items.length
          feed.items.reverse.each do |item|
            p item.link
            unless @feeds.include? item.link
              @feeds << item.link
              p @feeds.length
              # to prevent the first run displays all the items
              if @feeds.length > feed.items.length
                @bot.config.options['cogconf']['rss']['announce'].each do |announce|
                  Channel(announce).send "#{item.title} (#{item.link})"
                end
              end
            end
          end
          if @feeds.length > feed.items.length
            @feeds = @feeds[-feed.items.length, feed.items.length]
          end
        end
      end

    end
  end
end
