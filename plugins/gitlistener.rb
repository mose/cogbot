module Cinch
  module Plugins
    class Gitlistener
      include Cinch::Plugin

      set :plugin_name, 'gitlistener'

      listen_to :api_callback

      def listen(m, json)
        hash = Yajl::Parser.parse(URI.unescape(json[8..-1]))
        #bot.loggers.debug(hash.inspect)
        @bot.config.options['cogconf']['main']['channels'].each do |channel|
        #['#dev'].each do |channel|
          hash['commits'].each do |c|
            Channel(channel).msg "%s@%s: %s [ %s ]" % [
              c['committer']['name'],
              hash['repository']['name'],
              c['message'],
              c['modified'].join(', ')
            ]
          end
        end
      end
    end
  end
end
