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
    url = "http://api.stackoverflow.com/docs/search#site=stackoverflow&sort=activity&intitle=#{CGI.escape(query)}"
p url
    res = JSON.parse(open(url))
p res
    res.items.each do |i|
      title = i.title
      link = i.link
      desc = i.tags.join(', ')
    end
    "#{title} - #{desc} (#{link})"
  rescue
    "No results found"
  end

  def execute(m, query)
    m.reply(search(query))
  end
end
