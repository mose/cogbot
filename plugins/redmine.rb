require 'open-uri'
require 'yajl'
require 'cgi'

module Cinch
  module Plugins
    class Redmine
      include Cinch::Plugin

      timer 60, method: :check_redmine

      set :plugin_name, 'redmine'
      set :help, <<EOT
Redmine plugins checks the new issues in the specified redmine instance
EOT

      def check_redmine
        @issues ||= Array.new
        api_key = @bot.config.options['cogconf']['redmine']['api_key']
        redmine_url = "%s/issues.json?project_id=%s&limit=20" % [
          @bot.config.options['cogconf']['redmine']['url'],
          @bot.config.options['cogconf']['redmine']['project']
        ]
        res = Yajl::Parser.parse(open(redmine_url, "X-Redmine-API-Key" => api_key))
        subjs = Hash[ res['issues'].map { |i| [ i['id'], i['subject'] ] } ]
        issues = subjs.keys
        newones = Array.new
        if @issues.count == 0
          @issues = issues
        else
          issues.each { |i| newones << i unless @issues.include? i  }
          if newones.count > 0
            newones.each do |i|
              @issues.push i
              @bot.config.options['cogconf']['main']['channels'].each do |channel|
                Channel(channel).msg "[%s] >>> %s - %s/issues/%s" % [
                  @bot.config.options['cogconf']['redmine']['project'],
                  subjs[i],
                  @bot.config.options['cogconf']['redmine']['url'],
                  i
                ]
              end
            end
            @issues = @issues[0..50]
          end
        end
        # puts "redmine: done #{newones.count} new issues, #{@issues.count} cached"
      rescue Exception => e
        puts "*** #{e.class}\n"
        puts e.to_s
        puts e.backtrace
      end

      def new(bot)
        @bot = bot
        @issues = Array.new
      end

    end
  end
end
