module TaskLoop
  require 'claide'

  class Command < CLAide::Command

    require 'taskloop/command/init'
    require 'taskloop/command/lint'
    require 'taskloop/command/list'
    require 'taskloop/command/log'
    require 'taskloop/command/register'
    require 'taskloop/command/unregister'
    require 'taskloop/command/run'

    self.abstract_command = true

    self.description = 'Taskloop Command Description.'

    self.command = 'taskloop'

    # def self.options
    #   [
    #     ['--verbose', 'Show detail information while executing command.']
    #   ].concat(super)
    # end



    def initialize(argv)
      # @verbose = argv.flag?('verbose', true)
      super
    end

    def run

    end

    def create_taskloop_dir_if_needed
      # create ~/.taskloop directory if needed.
      unless File.directory?(taskloop_dir)
        FileUtils.mkdir(taskloop_dir)
      end
    end

    def create_tasklist_if_needed
      # create ~/.taskloop/tasklist.json directory if needed.
      unless  File.file?(tasklist_path)
        file = File.new(tasklist_path, "w+")
        content = <<-DESC
{
   "path": [],
   "git": []
}
        DESC
        file.puts content
        file.close
      end
    end

    def taskloop_dir
      File.join(Dir.home, ".taskloop")
    end
    def tasklist_path
      File.join(Dir.home, [".taskloop", "tasklist.json"])
    end
    def taskfile_paths
      json_string = File.read(tasklist_path)
      parsed_json = JSON.parse(json_string)
      return parsed_json["path"]
    end
  end
end