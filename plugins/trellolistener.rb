require "cgi"

module Cinch
  module Plugins
    class Trellolistener
      include Cinch::Plugin

      set :plugin_name, 'trellolistener'

      listen_to :api_callback

      def listen(m, json)
        hash = Yajl::Parser.parse(URI.unescape(json[8..-1]))
        bot.loggers.debug(hash.inspect)
        @bot.config.options['cogconf']['main']['channels'].each do |channel|
          #['#dev'].each do |channel|
          action = hash['action']['type']
          author = hash['action']['memberCreator']['username']
          board = hash['action']['data']['board']['name']
          list = hash['action']['data']['list']['name']
          cardlink = hash['action']['data']['card']['shortLink']
          cardname = hash['action']['data']['card']['name']
          Channel(channel).msg "[%s] %s %s in %s: " % [
            board,
            author,
            action,
            list,
            cardname,
            link(cardlink)
          ]
        end
      end

      def link(x)
        ""https://trello.com/c/#{x}"
      end

    end
  end
end
