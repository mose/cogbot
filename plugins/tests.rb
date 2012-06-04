class Tests
  include Cinch::Plugin

  def new(bot)
    @bot = bot
  end

  match /hey you/

  def execute(m)
    m.reply "Who ? me ?"
  end

end
