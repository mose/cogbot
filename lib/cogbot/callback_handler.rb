module Cogbot
  class CallbackHandler
    include Cinch::Plugin

    listen_to :api_callback

    def listen(m, json_in)
      json = StringIO.new(json_in)
      parser = Yajl::Parser.new(:symbolize_keys => true)
      hash = parser.parse(json)
      config['main']['channels'].each do |channel|
        files, additions, subtractions = get_commit_details(changeset)
        hash[:commits].each do |c|
          Channel(channel).send "[%s:%s] %s <%s>" % [
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
