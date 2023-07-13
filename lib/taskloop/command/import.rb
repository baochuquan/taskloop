module TaskLoop
  class Import < Command
    self.abstract_command = false

    self.summary = "To import one or more environment variables into taskloop."

    self.description = <<-DESC
      The `taskloop import --env=[VAR1, VAR2...]` command will import one or more environment variables into taskloop. 
      All these variables will be shared with all the registered tasks. In detail, these variables will be record into 
      ~/.tasklooprc. If you want to do more things to these variables, edit ~/.tasklooprc by yourself.
    DESC

    def self.options
      [
        ['--env=VAR1,VAR2...', 'Use one or more environment variables to import into taskloop.']
      ].concat(super)
    end

    def initialize(argv)
      @envstring = argv.option('env')
      super
    end

    def validate!
      super
      unless @envstring
        help! "--env option is require while executing the 'taskloop import' command."
      end
    end

    def run
      super
      env_list = @envstring.split(',')
      unless env_list.length > 0
        puts "Warning: the environment variables you import is empty. Please check the option again.".ansi.yellow
        return
      end
      env_file = File.open(taskloop_environments_path, "a")
      env_list.each do |var|
        puts "importing #{var} ...".ansi.green
        puts "    #{var}=#{ENV[var]}".ansi.green
        env_file.puts "export #{var}=#{ENV[var]}"
      end
      puts ""
      puts "import environment variables complete.".ansi.green
      env_file.close
    end
  end
end