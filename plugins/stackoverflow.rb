require 'open-uri'
require 'json'

class Stackoverflow
  include Cinch::Plugin

  match /s (.+)/

  set :plugin_name, 'stackoverflow'
  set :help, <<EOT
Stackoverflow returns the first match on a search
.s  <keywords> : searches on those keywords
EOT

  def new(bot)
    @bot = bot
  end

  def search(query)
    url = "http://api.stackexchange.com/2.2/search?site=stackoverflow&pagesize=3&sort=activity&order=desc&intitle=#{CGI.escape(query)}"
    puts url

    resp = open(url, "Accept-Encoding" => "gzip,deflate")
    gz = Zlib::GzipReader.new(StringIO.new(resp.string))
    res = JSON.parse(gz.read)
    if res['items'].count == 0
      return "No results found."
    end
    back = ""
    res['items'].each do |i|
      title = i['title']
      link = i['link']
      desc = i['tags'].join(', ')
      back += "#{title} - #{desc} (#{link})\n"
    end
    back
  rescue
    "Query error."
  end

  def execute(m, query)
    m.reply(search(query))
  end
end
