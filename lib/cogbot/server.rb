require 'goliath'

class Server < Goliath::API
  use Goliath::Rack::Tracer             # log trace statistics
  use Goliath::Rack::DefaultMimeType    # cleanup accepted media types
  use Goliath::Rack::Render, 'json'     # auto-negotiate response format
  use Goliath::Rack::Params             # parse & merge query and body parameters
  use Goliath::Rack::Heartbeat          # respond to /status with 200, OK (monitoring, etc)
  use Goliath::Rack::Validation::RequestMethod, %w(GET POST)           # allow GET and POST requests only

  def process(params)
    params
  end

  def response(env)
    headers = { 'Content-Type' => 'text/plain', 'X-Stream' => 'Goliath' }
    [ 200, headers, process(env['params']) ]
  end

end


