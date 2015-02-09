require "cgi"

module Cinch
  module Plugins
    class Trellolistener
      include Cinch::Plugin

      set :plugin_name, 'trellolistener'

      listen_to :http_trellolistener

      def listen(m, json)
        hash = Yajl::Parser.parse(URI.unescape(json))
        bot.loggers.debug(hash.inspect)
        if  @bot.config.options['cogconf']['trello']
          @bot.config.options['cogconf']['trello']['announce'].each do |announce|
            if hash['action']['data']['board']['name'] == announce['board']
              channel = announce['channel']
              action = hash['action']['type']
              case action
              when 'createCard'
                message(channel, hash, "created \"%s\" in %s" % [
                  truncate(hash['action']['data']['card']['name']),
                  Format(:orange, hash['action']['data']['list']['name'])
                ])
              when 'updateCard'
                if hash['action']['data']['old']
                  if hash['action']['data']['old']['pos']
                    message(channel, hash, "moved \"%s\" in %s" % [
                      truncate(hash['action']['data']['card']['name']),
                      Format(:orange, hash['action']['data']['list']['name'])
                    ])
                  elsif hash['action']['data']['old']['desc']
                    message(channel, hash, "changed desc on \"%s\" in %s to \"%s\"" % [
                      truncate(hash['action']['data']['card']['name']),
                      Format(:orange, hash['action']['data']['list']['name']),
                      truncate(hash['action']['data']['card']['desc'])
                    ])
                  elsif hash['action']['data']['old']['closed'] != nil
                    if hash['action']['data']['card']['closed']
                      message(channel, hash, "archived \"%s\" from %s" % [
                        truncate(hash['action']['data']['card']['name']),
                        Format(:orange, hash['action']['data']['list']['name'])
                      ])
                    else
                      message(channel, hash, "restored \"%s\" in %s" % [
                        truncate(hash['action']['data']['card']['name']),
                        Format(:orange, hash['action']['data']['list']['name'])
                      ])
                    end
                  end
                end
              when 'addLabelToCard'
                message(channel, hash, "labelled \"%s\" as %s" % [
                  truncate(hash['action']['data']['card']['name']),
                  Format(:green, hash['action']['data']['label']['name'])
                ])
              when 'removeLabelFromCard'
                message(channel, hash, "unlabelled \"%s\" as %s" % [
                  truncate(hash['action']['data']['card']['name']),
                  Format(:grey, hash['action']['data']['label']['name'])
                ])
              when 'commentCard'
                message(channel, hash, "commented on \"%s\" in %s: %s" % [
                  truncate(hash['action']['data']['card']['name']),
                  Format(:orange, hash['action']['data']['list']['name']),
                  truncate(hash['action']['data']['text'])
                ])
              end
            end
          end
        end
      end

    private

      def link(x)
        "https://trello.com/c/#{x}"
      end

      def truncate(content, limit=50)
        message = ''
        words = content.gsub(/[\s\n]+/," ").split(" ")
        while words.count > 0
           word = words.shift
          if (message.size + word.size + 2) > limit
            message << ' …'
            words.clear
          else
            message << " #{word}"
          end
        end
        message.strip
      end

      def message(channel, hash, msg)
        Channel(channel).msg "%s %s %s %s" % [
          Format(:yellow, "[%s]" % hash['action']['data']['board']['name']),
          Format(:aqua, hash['action']['memberCreator']['username']),
          msg,
          Format(:grey, "(%s)" % link(hash['action']['data']['card']['shortLink']))
        ]
      end

    end
  end
end
