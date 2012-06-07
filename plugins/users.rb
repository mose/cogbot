
class Users

  class UserStruct < Struct.new(:user, :channel, :text, :time)
  end

  include Cinch::Plugin

  def initialize(*args)
    super
    storage[:users] ||= {}
  end

  match /u (.+ )?([^\s]+)( .+)/

  def exec(query,nick)
    back ''
    query.strip! rescue ''
    nick.strip! rescue ''
    if query.blank?
    else
      case query
      when 'add'
      else
        back = "Unknown command #{query}."
      end
    end
    return back
  end

  def execute(m, query, nick, msg)
    m.reply(exec(query, nick, msg))
  end

end
