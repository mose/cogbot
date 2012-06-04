require 'cinch'
require "lib/cogbot/version"
require "lib/cogbot/utils"

module Cogbot

  def self.makebot
    config = YAML::load_file(CONFIG_FILE)
    plugins = Array.new
    config['main']['plugins'].each do |p|
      if File.exists?(File.join(ROOT_DIR,'plugins',"#{p}.rb"))
        require File.join(ROOT_DIR,'plugins',p)
        plugins.push Object.const_get(p.camelize)
      end
    end
    bot = Cinch::Bot.new do
      configure do |c|
        c.server = config['main']['server']
        c.nick = config['main']['nick']
        c.channels = config['main']['channels']
        c.options = { 'cogconf' => config }
        c.plugins.prefix = config['main']['prefix']
        c.plugins.plugins = plugins
      end
      on :message, "hi" do |m|
        m.reply "Hello, #{m.user.nick}"
      end
    end
    bot
  end

end
