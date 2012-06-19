module Cogbot
  class CallbackHandler
    include Cinch::Plugin

    listen_to :api_callback

    def listen(m, json)
      hash = Yajl::Parser.parse(URI.unescape(json[8..-1]))
      bot.loggers.debug(hash.inspect)
      #@bot.config.options['cogconf']['main']['channels'].each do |channel|
      ['#cinch-bots'].each do |channel|
        Channel(channel).msg "[%s:%s] %s <%s>" % [
          hash['repository']['name'],
          hash['pusher']['name'],
          hash['head_commit']['message'],
          hash['head_commit']['url']
        ]
      end
    end

  end
end
