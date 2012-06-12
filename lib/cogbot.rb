require 'cinch'
#require 'cinch/storage/yaml'
require "lib/cogbot/version"
require "lib/cogbot/utils"

module Cogbot

  def self.makebot
    config = {}
    begin
      config = YAML::load_file(CONFIG_FILE)
    rescue Exception => e
      load "lib/cogbot/setup.rb"
      config['main'] = Cogbot::Setup.init
    end
    plugins = Array.new
    config['main']['plugins'].each do |p|
      if File.exists?(File.join(ROOT_DIR,'plugins',"#{p}.rb"))
        require File.join(ROOT_DIR,'plugins',p)
        plugins.push Cinch::Plugins.const_get(p.camelize)
      end
    end
    bot = Cinch::Bot.new do
      configure do |c|
        c.server = config['main']['server']
        c.ssl.use = ( config['main']['ssl'] == 'true' )
        c.nick = config['main']['nick']
        c.user = config['main']['nick']
        c.realname = config['main']['nick']
        c.channels = config['main']['channels']
        c.options = { 'cogconf' => config }
        c.plugins.prefix = config['main']['prefix']
        c.plugins.plugins = plugins
        #c.storage.backend = Cinch::Storage::YAML
        #c.storage.basedir = File.join(ROOT_DIR,"yaml")
        #c.storage.autosave = true
      end
      on :message, "hi" do |m|
        m.reply "Hello, #{m.user.nick}"
      end
    end
    bot
  end

end
