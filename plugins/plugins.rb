require 'active_support/all'

class Plugins
  include Cinch::Plugin

  match /p( .+)?$/

  set :help, <<EOF
help for the Plugins plugin
  list        : list loaded plugins
  reload <p>  : reload plugin <p>
  help <p>    : show help for plugin <p>
EOF

  def loaded plugin
    @bot.config.plugins.plugins.any? { |p| p.to_s.downcase == plugin }
  end

  def exec(query)
    query.strip! rescue ''
    back = ''
    case query
    when /^help( .*)$/
      plug = $1.strip.downcase
      back = plug
      if loaded plug
        klaz = Object.const_get(plug.camelize)
        unless klaz.help.blank?
          back = klaz.help
        else
          back = "No help available for the plugin #{plug.camelize}."
        end
      else
        back = "Plugin '#{plug}' not found."
      end
    when /^reload( .*)$/
      plug = $1.strip.downcase
      if loaded plug
        begin
          load "plugins/#{plug}.rb"
          back = "#{$1.strip} reloaded."
        rescue Exception => e
          back = "*** #{e.class}\n"
          back += e.to_s
        end
      else
        back = "Plugin '#{plug}' not found."
      end
    when /^list/
      @bot.config.plugins.plugins.each { |p| back += "#{p.name} " }
    else
      back = "commands: list, reload <plugin>\n"
      back += "  Commands to work with plugins. use 'help <plugin>' for more info."
    end
    return back
  end

  def execute(m, query)
    m.reply(exec(query))
  end
end
