# doc on https://github.com/sferik/twitter
# get tokens on https://apps.twitter.com

require 'twitter'

module Cinch
  module Plugins
    class Tweet
      include Cinch::Plugin

      match /t ?([^ ]*)?( ?.*)/

      set :plugin_name, 'tweet'
      set :help, <<EOT
Tweet makes the bot can query twittter API
.t search <term> : searches the public timelines
EOT

      def client
        @_client ||= Twitter::REST::Client.new do |c|
          c.consumer_key        = @bot.config.options['cogconf']['tweet']['consumer_key']
          c.consumer_secret     = @bot.config.options['cogconf']['tweet']['consumer_secret']
          c.access_token        = @bot.config.options['cogconf']['tweet']['access_token']
          c.access_token_secret = @bot.config.options['cogconf']['tweet']['access_token_secret']
        end
      end

      def ago(timestamp)
        now = Time.now.utc
        timespent = now - timestamp
        case timespent
        when 0..60
          "#{timespent.round}s ago"
        when 61..3600
          "#{(timespent/60).floor}m ago"
        when 3601..86400
          "#{(timespent/3600).floor}h ago"
        when 86401..2592000
          "#{(timespent/86400).floor}d ago"
        when 2592001..31536000
          "#{(timespent/2592000).floor} month ago"
        else
          "more than one year ago"
        end
      end

      def new(bot)
        @bot = bot
      end

      def exec(command, args)
        back = ''
        #back += "command: #{command} / args: #{args}\n"
        begin
          case command
          when 'search'
            client.search(args).take(3).each do |status|
              back += Format(:bold, :underline, :yellow, "@#{status.user.screen_name}") 
              back += " #{status.text.gsub(/\n/,' ')}"
              back += " (#{ago(status.created_at)}"
              back += " https://twitter.com/#{status.user.screen_name}/status/#{status.id})"
              back += "\n"
            end
          else
            back += "Usage: .t search <term> : searches the public timelines"
            #back += Twitter.send(command,args.split(','))
          end
        rescue Exception => e
          back += "Bad request\n"
          back += e.inspect
          back += e.backtrace.join("\n")
        end
        return back
      end

      def execute(m,command,args)
        m.reply(exec(command,args.strip))
      end

    end
  end
end
