require 'open-uri'
require 'nokogiri'
require 'cgi'

class Google
  include Cinch::Plugin

  match /g (.+)/

  set :help, <<EOT
Google returns the first google match on a search
  <keywords> : searches on those keywords
EOT

  def search(query)
    url = "http://www.google.com/search?q=#{CGI.escape(query)}"
    res = Nokogiri::HTML(open(url)).at("h3.r")

    title = res.text
    link = res.at('a')[:href]
    link.gsub!(/^.*q=(.*)&sa.*$/) { $1 }
    desc = res.at("./following::div").children.first.text
    CGI.unescape_html "#{title} - #{desc} (#{link})"
  rescue
    "No results found"
  end

  def execute(m, query)
    m.reply(search(query))
  end
end
