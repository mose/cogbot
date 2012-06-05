class Dice
  include Cinch::Plugin

  match /roll$/, :use_prefix => false

  set :plugin_name, 'dice'
  set :help, <<EOT
.roll Rolls a dice.
EOT

  def new(bot)
    @bot = bot
  end

  def execute(m)
    score = rand(100) + 1
    m.reply("#{m.user.nick} rolls #{score}")
  end

end

