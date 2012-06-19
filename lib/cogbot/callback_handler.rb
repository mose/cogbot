module Cogbot
  class CallbackHandler
    include Cinch::Plugin

    listen_to :api_callback

    def listen(m, json)
      bot.loggers.debug(URI.unescape(json[8..-1]))
      hash = Yajl::Parser.parse(URI.unescape(json[8..-1]))
      @bot.config.options.cogconf['main']['channels'].each do |channel|
        hash[:commits].each do |c|
          Channel(channel).msg "[%s:%s] %s <%s>" % [
            hash[:repository][:name],
            c[:author][:name],
            c[:message],
            c[:url]
          ]
        end
      end
    end

  end
end
