require "cgi"

module Cinch
  module Plugins
    class Trellolistener
      include Cinch::Plugin

      set :plugin_name, 'trellolistener'

      listen_to :http_trellolistener

      def listen(m, json)
        hash = Yajl::Parser.parse(URI.unescape(json))
        #bot.loggers.debug(hash.inspect)
        if  @bot.config.options['cogconf']['trello']
          @bot.config.options['cogconf']['trello']['announce'].each do |announce|
            if hash['action']['data']['board']['name'] == announce['board']
              channel = announce['channel']
              action = hash['action']['type']
              case action
              when 'updateBoard'
                # not implemented yet
                # "prefs":{"cardAging":"pirate"}
                # "prefs":{"voting":"members"}
              when 'addMemberToBoard'
                message(channel, hash, "added %s to board" % [
                  Format(:aqua, hash['action']['member']['username'])
                ])
              when 'createCard'
                message(channel, hash, "created \"%s\" in %s" % [
                  truncate(hash['action']['data']['card']['name']),
                  Format(:orange, hash['action']['data']['list']['name'])
                ])
              when 'addMemberToCard'
                message(channel, hash, "added %s to \"%s\"" % [
                  Format(:aqua, hash['action']['member']['username']),
                  truncate(hash['action']['data']['card']['name'])
                ]) or puts json
              when 'removeMemberFromCard'
                message(channel, hash, "removed %s from \"%s\"" % [
                  Format(:aqua, hash['action']['member']['username']),
                  truncate(hash['action']['data']['card']['name'])
                ]) or puts json
              when 'updateCard'
                if hash['action']['data']['old']
                  if hash['action']['data']['listAfter']
                    message(channel, hash, "moved \"%s\" from %s to %s" % [
                      truncate(hash['action']['data']['card']['name']),
                      Format(:orange, hash['action']['data']['listBefore']['name']),
                      Format(:orange, hash['action']['data']['listAfter']['name'])
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
                  elsif hash['action']['data']['old'].has_key? 'due'
                    if hash['action']['data']['card']['due'] && hash['action']['data']['old']['due']
                      date_new = Date.parse(hash['action']['data']['card']['due']).strftime("%a %-d %b")
                      date_old = Date.parse(hash['action']['data']['old']['due']).strftime("%a %-d %b")
                      message(channel, hash, "changed date on \"%s\" in %s, from %s to %s" % [
                        truncate(hash['action']['data']['card']['name']),
                        Format(:orange, hash['action']['data']['list']['name']),
                        Format(:yellow, date_old),
                        Format(:yellow, date_new)
                      ])
                    elsif hash['action']['data']['card']['due']
                      date_new = Date.parse(hash['action']['data']['card']['due']).strftime("%a %-d %b")
                      message(channel, hash, "set date on \"%s\" in %s, to %s" % [
                        truncate(hash['action']['data']['card']['name']),
                        Format(:orange, hash['action']['data']['list']['name']),
                        Format(:yellow, date_new)
                      ])
                    else
                      date_old = Date.parse(hash['action']['data']['old']['due']).strftime("%a %-d %b")
                      message(channel, hash, "removed date on \"%s\" in %s, was \"%s\"" % [
                        truncate(hash['action']['data']['card']['name']),
                        Format(:orange, hash['action']['data']['list']['name']),
                        Format(:yellow, date_old)
                      ])
                    end
                  else
                    puts "---- no known old ----"
                    bot.loggers.debug(json)
                    puts "---- / no known old ----"
                  end
                else
                  puts "---- no old ----"
                  bot.loggers.debug(json)
                  puts "---- / no old ----"
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
              when 'addChecklistToCard'
                message(channel, hash, "added checklist \"%s\" on \"%s\"" % [
                  truncate(hash['action']['data']['checklist']['name']),
                  truncate(hash['action']['data']['card']['name'])
                ])
              when 'createCheckItem'
                message(channel, hash, "added \"%s\" in checklist \"%s\" on \"%s\"" % [
                  truncate(hash['action']['data']['checkItem']['name']),
                  truncate(hash['action']['data']['checklist']['name']),
                  truncate(hash['action']['data']['card']['name'])
                ])
              else
                puts "------------- not yet implemented: #{action} ------"
                bot.loggers.debug(json)
                puts "---------------------------------------------------"
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
        Channel(channel).send("%s %s %s %s" % [
          Format(:yellow, "[%s]" % hash['action']['data']['board']['name']),
          Format(:aqua, hash['action']['memberCreator']['username']),
          msg,
          Format(:grey, "(%s)" % link(hash['action']['data']['card']['shortLink']))
        ])
      end

    end
  end
end
