require 'twitter'

class Tweet
  include Cinch::Plugin

  match /t ?([^ ]*)?( ?.*)/

  set :help, <<EOT
Tweet makes the bot can query twittter API
  search <term> : searches the public timelines
EOT

=begin
  Twitter.configure do |c|
    c.consumer_key = @bot.config.options.cogconf['tweet']['consumer_key']
    c.consumer_secret = @bot.config.options.cogconf['tweet']['consumer_secret']
    c.oauth_token = @bot.config.options.cogconf['tweet']['oauth_token']
    c.oauth_token_secret = @bot.config.options.cogconf['tweet']['oauth_token_secret']
  end
=end

  def exec(command,args)
    back = ''
    #back += "command: #{command} / args: #{args}\n"
    begin
      case command
      when 'search'
        Twitter.search(args, { :lang => 'en', :rpp => '3' }).each do|status|
          back += status.full_text + "\n"
        end
      else
        back += Twitter.send(command,args.split(','))
      end
    rescue Exception => e
      back += "Bad request\n"
      back += e.inspect
    end
    return back
  end

  def execute(m,command,args)
    m.reply(exec(command,args.strip))
  end

end

