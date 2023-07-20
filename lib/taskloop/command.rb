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

      unless File.directory?(taskloop_data_dir)
        FileUtils.mkdir(taskloop_data_dir)
      end

      unless File.directory?(taskloop_repo_dir)
        FileUtils.mkdir(taskloop_repo_dir)
      end

      # create files
      create_project_list_if_needed
      create_repo_list_if_needed
    end

    def create_project_list_if_needed
      unless File.file?(taskloop_project_list_path)
        file = File.new(taskloop_project_list_path, "w+")
        content = "[]"
        file.puts content
        file.close
      end
    end

    def create_repo_list_if_needed
      unless File.file?(taskloop_repo_list_path)
        file = File.new(taskloop_repo_list_path, "w+")
        content = "[]"
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
      File.join(taskloop_dir, "cronlog")
    end

    def taskloop_cron_tab_path
      File.join(taskloop_dir, "crontab")
    end

    def taskloop_environments_path
      File.join(taskloop_dir, "environments")
    end

    def taskloop_project_list_path
      File.join(taskloop_dir, "projectlist")
    end

    def taskloop_repo_list_path
      File.join(taskloop_dir, "repolist")
    end

    def taskloop_data_dir
      File.join(taskloop_dir, "data")
    end

    def taskloop_repo_dir
      File.join(taskloop_dir, "repo")
    end
    def taskfile_dirs
      # TODO: @baocq
      json_string = File.read(taskloop_project_list_path)
      parsed_json = JSON.parse(json_string)
      return parsed_json["paths"]
    end

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