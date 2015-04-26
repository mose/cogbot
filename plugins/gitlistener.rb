require "cgi"

module Cinch
  module Plugins
    class Gitlistener
      include Cinch::Plugin

      set :plugin_name, 'gitlistener'

      listen_to :http_gitlistener

      def listen(m, json)
        hash = Yajl::Parser.parse(URI.unescape(json[8..-1]))
        bot.loggers.debug(hash.inspect)
        @bot.config.options['cogconf']['main']['channels'].each do |channel|
        #['#dev'].each do |channel|
          hash['commits'].each do |c|
            Channel(channel).msg "%s@%s: %s %s" % [
              c['committer']['name'],
              hash['repository']['name'],
              CGI::unescape(c['message']),
              files(c)
            ]
          end
        end
      end

      def short(x)
        x.map { |l| l.gsub(/([^\/]*)\//) { |s| s[0,1] + '/'} }
      end

      def files(c)
        back = ""
        back += '[= ' + short(c['modified']).join(' ') + ' ] ' unless c['modified'].empty?
        back += '[- ' + short(c['removed']).join(' ') + ' ] ' unless c['removed'].empty?
        back += '[+ ' + short(c['added']).join(' ') + ' ] ' unless c['added'].empty?
        back   
      end

    end
  end
end
