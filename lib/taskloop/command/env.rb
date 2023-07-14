module TaskLoop
  class Env < Command
    self.abstract_command = false

    self.summary = "To import one or more environment variables into taskloop."

    self.description = <<-DESC
      The `taskloop env` command can be used to deal with environment variable related operations. 
      For example, you can export environment variables into taskloop with `--export=VAR1,VAR2...` options.
      Beside, you can list all the environment variables exported in taskloop.
      All above operations are based on ~/.taskloop/environments file. If you want more details about environment
      variables, check and edit ~/.taskloop/environments by yourself.
    DESC

    def self.options
      [
        ['--list', "To list all the environment variables exported in taskloop."],
        ['--export=VAR1,VAR2...', 'Use one or more environment variables to import into taskloop.']
      ].concat(super)
    end

    def initialize(argv)
      @export = argv.option('export')
      @list = argv.flag?('list', false)
      # TODO: @baocq delete
      puts "debug: @export => #{@export}"
      puts "debug: @list => #{@list}"
      super
    end

    def run
      super
      if @export
        export_environment_variables
        return
      end

      if @list
        list_environment_variables
      end
    end

    def validate!
      super
      if @export and @list
        help! "The --export option and the --list option cannot be used simultaneously."
      end
    end

    def export_environment_variables
      env_list = @export.split(',')
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

    def list_environment_variables
      env_list = {}
      env_file = File.open(taskloop_environments_path, "r")
      pattern = /\Aexport /
      env_file.each_line do |line|
        if line.match(pattern)
          left = line.index(" ")
          right = line.index("=")
          if left and right
            name = line[left..right]
            value = line[right+1..-1]
            env_list[name] = value
          end
        end
      end
      env_list.each do |k, v|
        puts k + '=' + v
      end
    end
  end
end