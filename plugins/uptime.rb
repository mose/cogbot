class Uptime
  include Cinch::Plugin

  match /uptime/

  def execute(m)
    m.reply "uptime:" + `uptime`
  end

end

