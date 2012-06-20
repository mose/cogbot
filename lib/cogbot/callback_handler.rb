module Cogbot
  class CallbackHandler
    include Cinch::Plugin

    listen_to :api_callback

    def listen(m, json)
      hash = Yajl::Parser.parse(URI.unescape(json[8..-1]))
      bot.loggers.debug(hash.inspect)
      #@bot.config.options['cogconf']['main']['channels'].each do |channel|
      ['#dev'].each do |channel|
        Channel(channel).msg "%s@%s: %s <%s>" % [
          hash['pusher']['name'],
          hash['repository']['name'],
          hash['head_commit']['message'],
          hash['head_commit']['modified'].join(', ')
        ]
      end
    end

  end
end
