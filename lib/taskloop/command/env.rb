module TaskLoop
  class Env < Command
    self.abstract_command = false

    self.summary = "To import one or more global environment variables into taskloop."

    self.description = <<-DESC
      The `taskloop env` command can be used to deal with global environment variable related operations. 
      For example, you can export environment variables into taskloop with `--import=VAR1,VAR2...` options.
      Beside, you can list all the global environment variables exported in taskloop.
      All above operations are based on ~/.taskloop/environments file. If you want more details about global environment
      variables, check and edit ~/.taskloop/environments by yourself.
    DESC

    def self.options
      [
        ['--import=VAR1,VAR2...', 'Import one or more global environment variables into taskloop.'],
        ["--remove=VAR1,VAR2...", 'Remove one or more global environment variables from taskloop.']
      ].concat(super)
    end

    def initialize(argv)
      @import = argv.option('import')
      @remove = argv.option('remove')
      super
    end

    def run
      super
      if @import == nil && @remove == nil
        list_environment_variables
        return
      end

      if @import
        import_environment_variables
      end

      if @remove
        remove_environment_variables
      end
    end

    def validate!
      super
      if @export && @list
        help! "The --global-export option and the --global-list option cannot be used simultaneously."
      end
      if @remove && @list
        help! "The --global-remove option and the --global-list option cannot be used simultaneously."
      end
    end

    def import_environment_variables
      env_list = @import.split(',')
      unless env_list.length > 0
        puts "Warning: the global environment variables you import is empty. Please check the option arguments again.".ansi.yellow
        return
      end
      env_file = File.open(taskloop_environments_path, "a")
      env_list.each do |var|
        puts "importing #{var} ...".ansi.blue
        puts "    #{var}=#{ENV[var]}".ansi.blue
        env_file.puts "export #{var}=#{ENV[var]}"
      end
      puts ""
      puts "import global environment variables complete.".ansi.blue
      env_file.close
    end

    def remove_environment_variables
      env_list = @remove.split(',')
      unless env_list.length > 0
        puts "Warning: the global environment variables you import is empty. Please check the option arguments again.".ansi.yellow
        return
      end

      file_content = []
      File.open(taskloop_environments_path, "r") do |file|
        file.each_line do |line|
          name = get_environment_variable_from_line(line)
          unless env_list.include?(name)
            file_content.push(line)
          end
        end
      end

      File.open(taskloop_environments_path, "w") do |file|
        file_content.each do |line|
          file.puts line
        end
      end
      puts "remove global environment variables complete.".ansi.blue
    end

    def list_environment_variables
      env_list = {}
      env_file = File.open(taskloop_environments_path, "r")
      pattern = /\Aexport /
      env_file.each_line do |line|
        if line.match(pattern)
          left = line.index(" ")
          right = line.index("=")
          if left && right
            name = line[left+1..right-1]
            value = line[left+1..-1]
            env_list[name] = value
          end
        end
      end
      if env_list.empty?
        puts "Warning: no global environment variable imported in taskloop.".ansi.blue
        return
      end
      puts "There are the global environments variables imported in taskloop:".ansi.blue
      env_list.each do |k, v|
        puts v
      end
    end

    private def get_environment_variable_from_line(line)
      pattern = /\Aexport /
      result = nil
      if line.match(pattern)
        left = line.index(" ")
        right = line.index("=")
        if left && right
          result = line[left+1..right-1]
        end
      end
      return result
    end
  end
end