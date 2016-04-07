require 'open-uri'
require 'rss'

module Cinch
  module Plugins
    class Rss
      include Cinch::Plugin

      set :plugin_name, 'rss'
      set :help, <<EOT
The RSS plugin will poll rss feed every options['cogconf']['rss']['polling'] minutes
EOT

      def initialize(bot)
        super
        @bot = bot
        @feeds = {}
        timer = Timer @bot.config.options['cogconf']['rss']['polling'], method: :fetch_rss
        timers << timer
      end

      def fetch_rss
        @bot.debug 'Fetching rss'
        @feeds ||= {}
        @bot.config.options['cogconf']['rss']['channels'].each do |chan|
          prefix = chan['prefix']
          open(chan['url']) do |rss|
            feed = RSS::Parser.parse(rss)
            @feeds[prefix] ||= []
            feed.items.reverse.each do |item|
              unless @feeds[prefix].include? item.link
                @feeds[prefix] << item.link
                # to prevent the first run displays all the items
                if @feeds[prefix].length > feed.items.length
                  chan['announce'].each do |announce|
                    msg = "#{prefix} #{item.title} (#{item.link})"
                    if chan['transform']
                      msg.gsub! Regexp.new(chan['transform']['regexp']), chan['transform']['replace']
                    end
                    Channel(announce).send msg
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
