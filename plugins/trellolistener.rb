require "cgi"

module Cinch
  module Plugins
    class Trellolistener
      include Cinch::Plugin

      set :plugin_name, 'trellolistener'

      listen_to :api_callback

      def listen(m, json)
        hash = Yajl::Parser.parse(URI.unescape(json))
        bot.loggers.debug(hash.inspect)
        if  @bot.config.options['cogconf']['trello']
        @bot.config.options['cogconf']['trello']['announce'].each do |channel|
          action = hash['action']['type']
	  case action
	  when 'createCard'
          Channel(channel).msg "%s %s created in %s: %s %s" % [
            Format(:yellow, "[%s]" % hash['action']['data']['board']['name']),
            Format(:aqua, hash['action']['memberCreator']['username']),
            Format(:orange, hash['action']['data']['list']['name']),
            hash['action']['data']['card']['name'],
            Format(:grey, "(%s)" % link(hash['action']['data']['card']['shortLink']))
          ]
	  when 'updateCard'
          Channel(channel).msg "%s %s moved in %s: %s %s" % [
            Format(:yellow, "[%s]" % hash['action']['data']['board']['name']),
            Format(:aqua, hash['action']['memberCreator']['username']),
            Format(:orange, hash['action']['data']['list']['name']),
            hash['action']['data']['card']['name'],
            Format(:grey, "(%s)" % link(hash['action']['data']['card']['shortLink']))
          ]
	  when 'addLabelToCard'
          Channel(channel).msg "%s %s labelled as %s: %s %s" % [
            Format(:yellow, "[%s]" % hash['action']['data']['board']['name']),
            Format(:aqua, hash['action']['memberCreator']['username']),
            Format(:green, hash['action']['data']['label']['name']),
            hash['action']['data']['card']['name'],
            Format(:grey, "(%s)" % link(hash['action']['data']['card']['shortLink']))
          ]
	  when 'removeLabelFromCard'
          Channel(channel).msg "%s %s unlabelled as %s: %s %s" % [
            Format(:yellow, "[%s]" % hash['action']['data']['board']['name']),
            Format(:aqua, hash['action']['memberCreator']['username']),
            Format(:grey, hash['action']['data']['label']['name']),
            hash['action']['data']['card']['name'],
            Format(:grey, "(%s)" % link(hash['action']['data']['card']['shortLink']))
          ]
	  end
        end
        end
      end

      def link(x)
        "https://trello.com/c/#{x}"
      end

    end
  end
end
