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
        @feeds ||= {}
        @bot.config.options['cogconf']['rss']['channels'].each do |channel|
          prefix = channel['prefix']
          open(@bot.config.options['cogconf']['rss']['channel']) do |rss|
            feed = RSS::Parser.parse(rss)
            @feeds[prefix] ||= []
            feed.items.reverse.each do |item|
              unless @feeds[prefix].include? item.link
                @feeds[prefix] << item.link
                # to prevent the first run displays all the items
                if @feeds[prefix].length > feed.items.length
                  @bot.config.options['cogconf']['rss']['announce'].each do |announce|
                    Channel(announce).send "#{prefix} #{item.title} (#{item.link})"
                  end
                end
              end
            end
            if @feeds[prefix].length > feed.items.length
              @feeds[prefix] = @feeds[prefix][-feed.items.length, feed.items.length]
            end
          end
        end
      end

    end
  end
end
