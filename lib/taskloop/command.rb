module TaskLoop
  require 'claide'

  class Command < CLAide::Command
    require 'digest'
    require 'taskloop/extension/string_extension'
    require 'taskloop/command/init'
    require 'taskloop/command/list'
    require 'taskloop/command/log'
    require 'taskloop/command/deploy'
    require 'taskloop/command/run'
    require 'taskloop/command/launch'
    require 'taskloop/command/shutdown'
    require 'taskloop/command/env'

    self.abstract_command = true

    self.description = <<-DESC
      Taskloop is a scheduled task manager based on cron. It offers a more clear syntax, more convenient log management. 
      It also solves environment variable import issues, and provides a more user-friendly experience.'
    DESC

    self.command = 'taskloop'

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
      # create ~/.taskloop/ dir
      create_dir_if_needed(taskloop_dir)
      # create ~/.taskloop/projlist file
      unless File.exists?(taskloop_proj_list_path)
        projlist = File.new(taskloop_proj_list_path, "w+")
        projlist.puts "[]"
        projlist.close
      end

      # create ~/.taskloop/crontab file
      create_file_if_needed(taskloop_cron_tab_path)
      # create ~/.taskloop/cronlog file
      create_file_if_needed(taskloop_cron_log_path)

      # create ~/.taskloop/data/ dir
      create_dir_if_needed(taskloop_data_dir)
    end

    def create_file_if_needed(path)
      unless File.file?(path)
        File.new(path, "w")
      end
    end
    def create_dir_if_needed(dir)
      unless File.directory?(dir)
        FileUtils.mkdir(dir)
      end
    end

    def tasklooprc_path
      File.join(Dir.home, ".tasklooprc")
    end

    def taskloop_dir
      File.join(Dir.home, ".taskloop")
    end

    def taskloop_cron_log_path
      File.join(taskloop_dir, "cronlog")
    end

    def taskloop_cron_tab_path
      File.join(taskloop_dir, "crontab")
    end

    def taskloop_environments_path
      File.join(taskloop_dir, "environments")
    end

    def taskloop_proj_list_path
      File.join(taskloop_dir, "projlist")
    end

    def taskloop_data_dir
      File.join(taskloop_dir, "data")
    end

    def taskloop_proj_list_dirs
      json_string = File.read(taskloop_proj_list_path)
      parsed_json = JSON.parse(json_string)
      return parsed_json
    end

    def taskloop_data_proj_dirs
      dirs = Dir.entries(taskloop_data_dir)
      result = []
      dirs.each do |dir|
        if dir != '.' && dir != '..'
          result.push(dir)
        end
      end
      return result
    end

    def taskloop_taskfile_paths
      paths = taskloop_data_proj_dirs
      result = []
      paths.each do |path|
        result.push(File.join(path, "Taskfile.deploy"))
      end
      return result
    end
    # def taskfile_dirs
    #   # TODO: @baocq
    #   json_string = File.read(taskloop_proj_list_path)
    #   parsed_json = JSON.parse(json_string)
    #   return parsed_json["paths"]
    # end

    LOGO = <<-DESC
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@          @@@@@@@@@@@@@@@@@@@@@@   @@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@    @@@@@@    @@@@@       @@@   @@   @@    @@@@@      @@@@      @@@       @@@@@@@@@
@@@@@@@@@@@    @@@@   @@   @@   @@@   @@   @   @@@    @@@@   @@   @@   @@   @@   @@   @@@@@@@@
@@@@@@@@@@@    @@@@@@@@@   @@@    @@@@@@      @@@@    @@@@   @@   @@   @@   @@   @@   @@@@@@@@
@@@@@@@@@@@    @@@@        @@@@@@    @@@      @@@@    @@@@   @@   @@   @@   @@   @@   @@@@@@@@
@@@@@@@@@@@    @@@   @@@   @@   @@@   @@   @   @@@    @@@@   @@   @@   @@   @@   @@   @@@@@@@@
@@@@@@@@@@@    @@@@        @@@       @@@   @@   @@      @@@      @@@@      @@@       @@@@@@@@@
@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@
@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    DESC
  end
end