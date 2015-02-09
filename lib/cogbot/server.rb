class Server < EM::Connection
  include EM::HttpServer

  def initialize(bot)
    @bot = bot
  end

  def post_init
    super
    no_environment_strings
  end

  def process_http_request
    if @http_request_method == "POST"
      pluginlist = @bot.plugins.map { |e| e.class.name.split('::').last.downcase }
      query = @http_request_uri[1..-1]
      if pluginlist.include? query
        @bot.handlers.dispatch("http_#{query}".to_sym, nil, @http_post_content)
      end
    end

    response = EM::DelegatedHttpResponse.new(self)
    response.status = 200
    response.send_response
  end
end
