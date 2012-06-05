class Tests
  include Cinch::Plugin

  set :plugin_name, 'tests'
  set :help, 'just a plugin for dev tests'

  match /hey you/

  def new(bot)
    @bot = bot
  end


  def execute(m)
    m.reply "Who ? me ?"
  end

end
