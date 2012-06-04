class Plugins
  include Cinch::Plugin

  match /p( .+)?$/

  set :plugin_name, 'plugins'
  set :help, <<EOF
help for the Plugins plugin
.p list        : list loaded plugins
.p load <p>    : load plugin <p>
.p unload <p>  : unload plugin <p>
.p reload <p>  : reload plugin <p>
.p help <p>    : show help for plugin <p>
EOF

  def new(bot)
    @bot = bot
  end

  def loaded plugin
    @bot.plugins.any? { |p| p.class.to_s.downcase == plugin }
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
        unless klaz.help == ''
          back = klaz.help
        else
          back = "No help available for the plugin #{plug.camelize}."
        end
      else
        back = "Plugin '#{plug}' not found."
      end
    when /^load( .*)$/
      plug = $1.strip.downcase
      if loaded plug
        return "Plugin '#{plug}' is already loaded."
      end
      if File.exists?(File.join(ROOT_DIR,'plugins',"#{plug}.rb"))
        begin
          load "plugins/#{plug}.rb"
          @bot.plugins.register_plugin Object.const_get(plug.camelize)
          back = "Plugin '#{plug}' loaded."
        rescue Exception => e
          back = "*** #{e.class}\n"
          back += e.to_s
        end
      else
        back = "Plugin '#{plug}' not found."
      end
    when /^unload( .*)$/
      plug = $1.strip.downcase
      if loaded plug
        @bot.plugins.unregister_plugin Object.const_get(plug.camelize)
        back = "Plugin '#{plug}' unloaded."
      else
        back = "Plugin '#{plug}' is not loaded, sorry."
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
      @bot.plugins.each { |p| back += "#{p.class} " }
    else
      back = "commands: list, load <plugin>, unload <plugin, reload <plugin>, help <plugin>\n"
      back += "  Commands to work with plugins. use 'help <plugin>' for more info."
    end
    return back
  end

  def execute(m, query)
    m.reply(exec(query))
  end
end
