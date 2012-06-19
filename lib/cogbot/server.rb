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
      @bot.dispatch(:api_callback, nil, @http_post_content)
    end

    response = EM::DelegatedHttpResponse.new(self)
    response.status = 200
    response.send_response
  end
end
