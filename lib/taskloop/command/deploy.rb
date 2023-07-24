
module TaskLoop
  class Deploy < Command
    require_relative '../task/task'
    require_relative '../rules/rule'
    require_relative '../rules/interval_rule'
    require_relative '../rules/scope_rule'
    require_relative '../rules/default_rule'
    require_relative '../rules/specific_rule'
    require_relative '../rules/after_scope_rule'
    require_relative '../rules/before_scope_rule'
    require_relative '../rules/between_scope_rule'
    require_relative '../rules/loop_rule'
    require_relative '../rules/date_list_rule'
    require_relative '../rules/time_list_rule'
    require_relative '../extension/string_extension'
    require_relative '../extension/integer_extension'
    require_relative '../dsl/dsl'
    require 'json'

    include TaskLoop::DSL

    self.abstract_command = false

    self.summary = "Deploy a Taskfile into taskloop."

    self.description = <<-DESC
      The `taskloop deploy` command will deploy a Taskfile into taskloop.
      Taskloop will record the path of a Taskfile into ~/.taskloop/tasklist.json.
    DESC

    def run
      super
      # check if Taskfile exist
      unless  File.file?(:Taskfile.to_s)
        puts "Error:".ansi.red
        puts "    Taskfile is not exist. Please goto the project's root directory and execute again, or run `taskloop init` command first if current directory is the root directory of a project.".ansi.red
        exit 1
      end

      register_taskfile_dir_if_needed
      unless deploy_lint?
        puts ""
        puts "Taskfile deploy failed. Please check Taskfile again.".ansi.red
        exit 1
      end

      generate_taskfile_deploy
    end


    def create_proj_file_structrue_if_needed

    end

    #################################
    # Register taskfile dir if needed
    #################################
    private def register_taskfile_dir_if_needed
      json_string = File.read(taskloop_proj_list_path)
      parsed_json = JSON.parse(json_string)
      # check if all the registered path
      push_taskfile_dir_if_needed(parsed_json)
    end

    private def push_taskfile_dir_if_needed(parsed_json)
      proj_dir = Dir.pwd
      duplicate = parsed_json.select { |path| path == proj_dir }
      if duplicate.empty?
        puts "First time to deploy current Taskfile.".ansi.blue
        puts "Register Taskfile into taskloop.".ansi.blue
        parsed_json.push(proj_dir)

        File.open(taskloop_proj_list_path, 'w') do |file|
          file.write(JSON.pretty_generate(parsed_json))
        end
      end
    end

    #################################
    # Deploy lint
    #################################
    private def deploy_lint?
      taskfile_path = Dir.pwd + "/Taskfile"

      eval_taskfile(taskfile_path)

      results = []
      for task in TaskLoop::Task::tasklist
        results.push(task.deploy_lint?)
      end
      return !results.include?(false)
    end

    private def eval_taskfile(path)
      string = File.open(path, 'r:utf-8', &:read)
      if string.respond_to?(:encoding) && string.encoding.name != 'UTF-8'
        string.encode!('UTF-8')
      end
      eval(string)
    rescue Exception => e
      raise TaskfileDeployError, "Error: Taskfile eval failed. Please check Taskfile again. #{e.message}"
    end

    #################################
    # Generate Taskfile.lock
    #################################

    private def generate_taskfile_deploy
      data_proj_dir = File.join(taskloop_data_dir, Dir.pwd.sha1_8bit)
      create_dir_if_needed(data_proj_dir)
      deploy_path = File.join(data_proj_dir, ".Taskfile.deploy")

      puts "Generate .Taskfile.deploy.".ansi.blue
      FileUtils.copy_file("Taskfile", deploy_path)
      puts "Taskfile deploy success.".ansi.blue
    end

  end
end