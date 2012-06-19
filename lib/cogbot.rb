require 'cinch'
require 'eventmachine'
require 'evma_httpserver'
require 'nokogiri'
require 'net/http'
require 'daemons'
require 'thor'
require 'yajl'
#require 'cinch/storage/yaml'
require "lib/cogbot/version"
require "lib/cogbot/utils"
require "lib/cogbot/server"
require "lib/cogbot/callback_handler"

module Cogbot

  class Bot < Thor

    desc "start", "start cogbot"
    def start

      # prepare config
      config = {}
      begin
        config = YAML::load_file(CONFIG_FILE)
      rescue Exception => e
        load "lib/cogbot/setup.rb"
        config['main'] = Cogbot::Setup.init
      end

      # prepare daemon
      Daemons.daemonize(
        :app_name => 'cogbot',
        :dir_mode => :normal,
        :log_dir => File.join('/', 'tmp'),
        :log_output => true,
        :dir => File.join('/', 'tmp')
      )

      # checkout plugins
      plugins = []
      config['main']['plugins'].each do |p|
        if File.exists?(File.join(ROOT_DIR,'plugins',"#{p}.rb"))
          require File.join(ROOT_DIR,'plugins',p)
          plugins.push Cinch::Plugins.const_get(p.camelize)
        end
      end
      plugins.push Cogbot::CallbackHandler

      # create bot
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

      Signal.trap('TERM') { EM.stop }

      EM.run do
        EM.defer { bot.start }
        EM.add_timer(3) do
          EM.start_server(
            config['server']['ip'],
            config['server']['port'],
            Server,
            bot
          )
        end
      end

      bot.quit
    end

    desc "stop", "stop cogbot"
    def stop
      pid_file = File.join('/', 'tmp', 'cogbot.pid')
      pid = File.read(pid_file).to_i if File.exist?(pid_file)
      Process.kill('TERM', pid)
    end

  end
end
