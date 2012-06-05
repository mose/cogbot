require 'open-uri'
require 'nokogiri'
require 'cgi'

class Urban
  include Cinch::Plugin

  match /u (.*)$/

  set :plugin_name, 'urban'
  set :help, <<EOT
Urban connects to urban dictionary and returns the first result
for a given query, replying with the result directly to the sender
EOT

  def query(query)
    url = "http://www.urbandictionary.com/define.php?term=#{CGI.escape(query)}"
    CGI.unescape_html Nokogiri::HTML(open(url)).at("div.definition").text.gsub(/\s+/, ' ')
  end

  def new(bot)
    @bot = bot
  end

  def execute(m,words)
    m.reply(query(words.strip))
  end

end

