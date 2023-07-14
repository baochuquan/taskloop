module TaskLoop
  require 'claide'

  class Command < CLAide::Command
    require 'digest'
    require 'taskloop/extension/string_extension'
    require 'taskloop/command/init'
    require 'taskloop/command/lint'
    require 'taskloop/command/list'
    require 'taskloop/command/log'
    require 'taskloop/command/register'
    require 'taskloop/command/unregister'
    require 'taskloop/command/run'
    require 'taskloop/command/launch'
    require 'taskloop/command/shutdown'
    require 'taskloop/command/env'

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
      create_taskloop_file_structure_if_needed
    end



    #################################
    # Path and Directory and Files
    #################################
    def create_taskloop_file_structure_if_needed
      # create Dirs
      unless File.directory?(taskloop_dir)
        FileUtils.mkdir(taskloop_dir)
      end

      unless File.directory?(taskloop_cache_dir)
        FileUtils.mkdir(taskloop_cache_dir)
      end

      unless File.directory?(taskloop_repos_dir)
        FileUtils.mkdir(taskloop_repos_dir)
      end

      # create files
      create_tasklist_json_if_needed
    end

    def create_tasklist_json_if_needed
      # create ~/.taskloop/tasklist.json directory if needed.
      unless  File.file?(tasklist_json_path)
        file = File.new(tasklist_json_path, "w+")
        content = <<-DESC
{
   "paths": [],
   "repos": []
}
        DESC
        file.puts content
        file.close
      end
    end

    def create_dir_if_needed(dir)
      unless File.directory?(dir)
        FileUtils.mkdir(dir)
      end
    end

    def taskloop_dir
      File.join(Dir.home, ".taskloop")
    end

    def tasklooprc_path
      File.join(Dir.home, ".tasklooprc")
    end

    def taskloop_cron_log_path
      File.join(taskloop_dir, "cron.log")
    end

    def taskloop_cron_tab_path
      File.join(taskloop_dir, "cron.tab")
    end

    def taskloop_environments_path
      File.join(taskloop_dir, "environments")
    end

    def tasklist_json_path
      File.join(taskloop_dir, "tasklist.json")
    end

    def taskloop_cache_dir
      File.join(taskloop_dir, "cache")
    end

    def taskloop_repos_dir
      File.join(taskloop_dir, "repos")
    end
    def taskfile_paths
      json_string = File.read(tasklist_json_path)
      parsed_json = JSON.parse(json_string)
      return parsed_json["paths"]
    end

    #################################
    # Hash
    #################################

  end
end