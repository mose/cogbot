require "fortune_gem"

class Fortune
  include Cinch::Plugin

  match /f$/

  set :plugin_name, 'fortune'
  set :help, <<EOT
.f gives you a bit of random wisdom.
EOT

  def new(bot)
    @bot = bot
  end

  def fortune
    max_length = 256
    fortune = FortuneGem.give_fortune(:max_length => max_length)
    fortune.gsub(/[\n]/, "").gsub(/[\t]/, " ").gsub("?A:", "? A:")
  end

  def execute(m)
    m.reply(fortune)
  end

end

