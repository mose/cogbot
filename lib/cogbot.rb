require 'cinch'
require 'eventmachine'
require 'evma_httpserver'
require 'nokogiri'
require 'net/http'
require 'daemons'
require 'thor'
require 'yajl'
require "lib/cogbot/utils"
require "lib/cogbot/server"

# main cogbot module
module Cogbot

  # cogbot cli parser and launcher
  class Bot < Thor

    desc "start", "start cogbot"
    # manages the start cli command
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
        :log_dir => LOG_DIR,
        :log_output => true,
        :dir => CONFIG_DIR
      )

      # checkout plugins
      plugins = []
      config['main']['plugins'].each do |p|
        if File.exists?(File.join(ROOT_DIR, 'plugins', "#{p}.rb"))
          require File.join(ROOT_DIR, 'plugins', p)
          plugins.push Cinch::Plugins.const_get(p.camelize)
        end
      end

      # create bot
      bot = Cinch::Bot.new do
        configure do |c|
          c.server = config['main']['server']
          c.ssl.use = ( config['main']['ssl'] == 'true' )
          c.nick = config['main']['nick']
          c.user = config['main']['nick']
          c.realname = config['main']['nick']
          c.channels = config['main']['channels']
          c.sasl.username = config['main']['sasl_user']
          c.sasl.password = config['main']['sasl_pass']
          c.options = { 'cogconf' => config }
          c.plugins.prefix = config['main']['prefix']
          c.plugins.plugins = plugins
        end
        on :message, "hi" do |m|
          m.reply "Hello, #{m.user.nick}"
        end
      end
      bot.loggers.debug(plugins.inspect)

      Signal.trap('TERM') { EM.stop }

      EM.run do
        EM.defer { bot.start }
        if config['server']
          EM.add_timer(3) do
            EM.start_server(
              config['server']['ip'],
              config['server']['port'],
              Server,
              bot
            )
          end
        end
      end

      bot.quit
    end

    desc "stop", "stop cogbot"
    # manages the stop cli command
    def stop
      pid_file = File.join(CONFIG_DIR, 'cogbot.pid')
      pid = File.read(pid_file).to_i if File.exist?(pid_file)
      Process.kill('TERM', pid)
    end

    desc "restart", "restart cogbot"
    # manages the restart cli command, just stopping and startinbg in sequence
    def restart
      stop
      start
    end

  end
end
