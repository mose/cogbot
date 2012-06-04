class Exec
  include Cinch::Plugin

  match /do ([^ ]*)( ?.*)/

  set :help, <<EOT
Exec is a commandline execution proxy: do <command> <pipe-grep> (only the 5 first lines will be displayed)
  psaux    : rnning processes
  df       : Disk free
  last     : last logged
  free     : free mem
  who      : who is logged
  uptime   : uptime and load average
EOT

  def exec(command,args)
    commands = {
      'psaux' => 'ps -aux',
      'df' => 'df -h',
      'last' => 'last',
      'free' => 'free -mol',
      'who' => 'w -shuo',
      'uptime' => 'uptime'
    }
    if command == 'help'
      return commands.inspect
    elsif !commands[command].nil?
      args.strip!
      line = commands[command]
      unless args.nil? || args == ''
        line += ' | grep ' + args.gsub(/;|&/,'')
      end
      line += '| head -5'
      back = line + "\n"
      back += `#{line}`
      return back
    else
      return "Command #{command} not found"
    end
  end

  def execute(m,command,args)
    m.reply(exec(command,args))
  end

end

