require "cgi"


module Cinch
  module Plugins

    class Trellolistener
      include Cinch::Plugin

      set :plugin_name, 'trellolistener'

      listen_to :http_trellolistener

      def listen(m, json)
        hash = Yajl::Parser.parse(URI.unescape(json))
        # bot.loggers.debug(hash.inspect)
        if @bot.config.options['cogconf']['trello']
          msg = TrelloMessage.new(hash['action'])
          output = msg.output
          if msg.notfound
            puts "------------- not yet implemented: #{hash['action']['type']} ------"
            bot.loggers.debug(json)
            puts "---------------------------------------------------"
            return
          end
                    
          @bot.config.options['cogconf']['trello']['announce'].each do |announce|
            if msg.board == announce['board']
              channel = announce['channel']
              Channel(channel).send(msg.output)
            end
          end
        end
      end

    end
  end
end


module Cinch
  module Plugins

    class TrelloMessage

      attr_reader :notfound

      def initialize(action)
        @creator = action['memberCreator']['username']
        @member = action['member']['username'] if action['member']
        @data = action['data']
        @type = action['type']
        @card = @data['card']['name'] ? truncate(@data['card']['name']) : @data['card']['id']
        @notfound = false
      end

      def format(*args)
        Cinch::Formatting.format(*args)
      end

      def board
        @data['board']['name']
      end

      def invalidate
        @notfound = true
      end

      def output
        if self.respond_to?(@type.to_sym)
          "%s %s %s %s" % [
            format(:yellow, "[%s]" % board),
            format(:aqua, @creator),
            self.send(@type.to_sym),
            format(:grey, "(%s)" % trellolink)
          ]
        else
          invalidate
        end
      end

      def trellolink
        "https://trello.com/c/#{@data['card']['shortLink']}"
      end

      def addMemberToBoard
        "added %s to board" % [
          format(:aqua, @member)
        ]
      end

      def removeMemberFromBoard
        "removed %s from board" % [
          format(:aqua, @member)
        ]
      end

      def createList
        "created new column %s" % [
          format(:orange, @data['list']['name'])
        ]
      end

      def updateList
        "changed column name %s to %s" % [
          format(:orange, @data['old']['name']),
          format(:yellow, @data['list']['name'])
        ]
      end

      def createCard
        "created \"%s\" in %s" % [
          @card,
          format(:orange, @data['list']['name'])
        ]
      end

      def deleteCard
        "deleted \"%s\" from %s" % [
          @card,
          format(:orange, @data['list']['name'])
        ]
      end

      def addMemberToCard
        "added %s to \"%s\"" % [
          format(:aqua, @member),
          @card
        ]
      end

      def removeMemberFromCard
        "removed %s from \"%s\"" % [
          format(:aqua, @member),
          @card
        ]
      end

      def updateCard
        if @data['old']
          if @data['listAfter']
            updateCard_moved
          elsif @data['old']['desc']
            updateCard_changed
          elsif @data['old']['closed'] != nil
            if @data['card']['closed']
              updateCard_archived
            else
              updateCard_restored
            end
          elsif @data['old'].has_key? 'due'
            if @data['card']['due'] && @data['old']['due']
              updateCard_changedate
            elsif @data['card']['due']
              updateCard_setdate
            else
              updateCard_removedate
            end
          else
            invalidate
          end
        else
          invalidate
        end
      end

      def updateCard_moved
        "moved \"%s\" from %s to %s" % [
          @card,
          format(:orange, @data['listBefore']['name']),
          format(:orange, @data['listAfter']['name'])
        ]
      end

      def updateCard_changed
        "changed desc on \"%s\" in %s to \"%s\"" % [
          @card,
          format(:orange, @data['list']['name']),
          truncate(@data['card']['desc'])
        ]
      end

      def updateCard_archived
        "archived \"%s\" from %s" % [
          @card,
          format(:orange, @data['list']['name'])
        ]
      end

      def updateCard_restored
        "restored \"%s\" in %s" % [
          @card,
          format(:orange, @data['list']['name'])
        ]
      end

      def updateCard_changedate
        "changed date on \"%s\" in %s, from %s to %s" % [
          @card,
          format(:orange, @data['list']['name']),
          format(:yellow, format_date(@data['card']['due'])),
          format(:yellow, format_date(@data['old']['due']))
        ]             
      end

      def updateCard_setdate
        "set date on \"%s\" in %s, to %s" % [
          @card,
          format(:orange, @data['list']['name']),
          format(:yellow, format_date(@data['card']['due']))
        ]
      end

      def updateCard_removedate
        "removed date on \"%s\" in %s, was \"%s\"" % [
          @card,
          format(:orange, @data['list']['name']),
          format(:yellow, format_date(@data['old']['due']))
        ]
      end

      def voteOnCard
        "voted on card \"%s\"" % [
          @card
        ]
      end

      def addLabelToCard
        "labelled \"%s\" as %s" % [
          @card,
          format(:green, @data['label']['name'])
        ]
      end

      def removeLabelFromCard
        "unlabelled \"%s\" as %s" % [
          @card,
          format(:grey, @data['label']['name'])
        ]
      end

      def updateLabel
        if @data['old']
          if @data['old']['name']
            "changed label name \"%s\" to \"%s\"" % [
              format(:orange, @data['old']['name']),
              format(:yellow, @data['label']['name'])
            ]
          elsif @data['old']['color']
            "changed label \"%s\" color from %s to %s" % [
              format(:green, @data['label']['name']),
              format(:orange, @data['old']['color']),
              format(:yellow, @data['label']['color'])
            ]
          else
            invalidate
          end
        else
          invalidate
        end
      end

      def commentCard
        "commented on \"%s\" in %s: %s" % [
          @card,
          format(:orange, @data['list']['name']),
          truncate(@data['text'])
        ]
      end

      def updateComment
        "updated comment on \"%s\" in %s: %s" % [
          @card,
          format(:orange, @data['list']['name']),
          truncate(@data['text'])
        ]
      end

      def deleteComment
        "deleted comment on \"%s\" in %s" % [
          @card,
          format(:orange, @data['list']['name']),
        ]
      end

      def addChecklistToCard
        "added checklist \"%s\" on \"%s\"" % [
          @data['checklist']['name'],
          @card
        ]
      end

      def updateChecklist
        "changed checklist \"%s\" to \"%s\"" % [
          @data['checkItem']['name'],
          @data['old']['name']
        ]
      end

      def createCheckItem
        "added \"%s\" in checklist \"%s\" on \"%s\"" % [
          @data['checkItem']['name'],
          @data['checklist']['name'],
          @card
        ]
      end

      def updateCheckItem
        "changed \"%s\" in checklist \"%s\" to \"%s\" on \"%s\"" % [
          @data['old']['name'],
          @data['checklist']['name'],
          @data['checkItem']['name'],
          @card
        ]
      end

      def updateCheckItemStateOnCard
        "changed state of \"%s\" in \"%s\"  to %s on \"%s\"" % [
          @data['checkItem']['name'],
          @data['checklist']['name'],
          format(:yellow, @data['checkItem']['state']),
          @card
        ]
      end

      def moveCardFromBoard
        "moved card \"%s\" to board %s" % [
          @card,
          format(:yellow, "[%s]" % @data['boardTarget']['name'])
        ]
      end

    private

      def format_date(time)
        Date.parse(time).strftime("%a %-d %b")
      end

      def truncate(content, limit=50)
        message = ''
        words = content.gsub(/[\s\n]+/," ").split(" ")
        while words.count > 0
           word = words.shift
          if (message.size + word.size + 2) > limit
            message << ' ...'
            words.clear
          else
            message << " #{word}"
          end
        end
        message.strip
      end

    end
  end
end

