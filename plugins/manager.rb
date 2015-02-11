# thx dominikh for this code :) (then slightly modified)
module Cinch
  module Plugins
    class Manager
      include Cinch::Plugin

      match(/m list/, method: :list_plugins)
      match(/m load (\S+)/, method: :load_plugin)
      match(/m unload (\S+)/, method: :unload_plugin)
      match(/m reload (\S+)/, method: :reload_plugin)
      match(/m set (\S+) (\S+) (.+)$/, method: :set_option)

      def authorized(m, &block)
        if @bot.config.options['cogconf']['manager']['admin'].include? m.user.nick
         instance_eval(&block)
        else
          m.reply "Sorry, you don't have the right."
        end
      end

      def list_plugins(m)
        back = ''
        @bot.plugins.each { |p| back += "#{p.class.name.split('::').last.downcase} " }
        m.reply back
      end

      def load_plugin(m, mapping)
        authorized m do
          plugin = mapping.downcase.camelize
          p plugin
          p mapping

          file_name = "#{ROOT_DIR}/plugins/#{mapping.downcase}.rb"
          unless File.exist?(file_name)
            m.reply "Could not load #{plugin} because #{File.basename(file_name)} does not exist."
            return
          end

          begin
            load(file_name)
          rescue Exception
            m.reply "Could not load #{plugin}."
            raise
          end

          begin
            const = Cinch::Plugins.const_get(plugin)
          rescue NameError
            m.reply "Could not load #{plugin} because no matching class was found."
            return
          end

          @bot.plugins.register_plugin(const)
          m.reply "Successfully loaded #{plugin}"
        end
      end

      def unload_plugin(m, plugin)
        authorized m do
          begin
            plugin_class = Cinch::Plugins.const_get(plugin.downcase.camelize)
          rescue NameError
            m.reply "Could not unload #{plugin} because no matching class was found."
            return
          end

          @bot.plugins.select {|p| p.class == plugin_class}.each do |p|
            @bot.plugins.unregister_plugin(p)
          end

          ## FIXME not doing this at the moment because it'll break
          ## plugin options. This means, however, that reloading a
          ## plugin is relatively dirty: old methods will not be removed
          ## but only overwritten by new ones. You will also not be able
          ## to change a classes superclass this way.
          # Cinch::Plugins.__send__(:remove_const, plugin)

          # Because we're not completely removing the plugin class,
          # reset everything to the starting values.
          plugin_class.hooks.clear
          plugin_class.matchers.clear
          plugin_class.listeners.clear
          plugin_class.timers.clear
          plugin_class.ctcps.clear
          plugin_class.react_on = :message
          plugin_class.plugin_name = nil
          plugin_class.help = nil
          plugin_class.prefix = nil
          plugin_class.suffix = nil
          plugin_class.required_options.clear

          m.reply "Successfully unloaded #{plugin}"
        end
      end

      def reload_plugin(m, plugin)
        authorized m do
          unload_plugin(m, plugin)
          load_plugin(m, plugin)
        end
      end

      def set_option(m, plugin, option, value)
        authorized m do
          begin
            const = Cinch::Plugins.const_get(plugin.downcase.camelize)
          rescue NameError
            m.reply "Could not set plugin option for #{plugin} because no matching class was found."
            return
          end
          @bot.config.plugins.options[const][option.to_sym] = eval(value)

          m.reply "Successfuly set option."
        end

      end
    end
  end
end
