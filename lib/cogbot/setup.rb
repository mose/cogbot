module Cogbot
  module Setup

    def self.setvalue default
      input = $stdin.gets.chomp
      if input == ''
        default
      else
        input
      end
    end

    def self.setbinary default
      input = $stdin.gets.chomp
      if input == ''
        default
      else
        input.downcase == 'y'
      end
    end

    def self.setlist default
      input = $stdin.gets.chomp
      if input == ''
        default
      else
        input.split(',')
      end
    end

    def self.init
      st = "\033[0;33m"
      en = "\033[m"

      default = YAML::load_file(File.join(ROOT_DIR,'config','cogbot.yml.defaults'))
      main = {}
      puts "You don't have a configuration file yet,"
      puts "let's make one in ~/.cogbot.yml"
      puts
      puts "Please answer those few questions"

      print "#{st}What name will cogbot use ?#{en} [#{default['main']['nick']}] "
      main['nick'] = setvalue default['main']['nick']

      print "#{st}What irc server #{main['nick']} will connect to ?#{en} [#{default['main']['server']}] "
      main['server'] = setvalue default['main']['server']

      print "#{st}What port #{main['nick']} will use to connect to #{main['server']} ?#{en} [#{default['main']['port']}] "
      main['port'] = setvalue default['main']['port']

      print "#{st}Will #{main['nick']} use SSL to connect to #{main['server']}:#{main['port']} ?#{en} [#{default['main']['ssl'] ? 'Yn' : 'yN'}] "
      main['ssl'] = setbinary default['main']['ssl']

      print "#{st}What channels #{main['nick']} should join ?#{en} [#{default['main']['channels'].join(',')}] "
      main['channels'] = setlist default['main']['channels']

      print "#{st}What prefix #{main['nick']} will use to understand he's talked to ?#{en} [#{default['main']['prefix']}] "
      main['prefix'] = setvalue default['main']['prefix']

      print "#{st}What plugins will be enabled for #{main['nick']} ?#{en} [#{default['main']['plugins'].join(',')}] "
      main['plugins'] = setlist default['main']['plugins']

      File.open(CONFIG_FILE,'w') { |f| YAML::dump({'main' => main},f) }
      return main
    end
  end
end

