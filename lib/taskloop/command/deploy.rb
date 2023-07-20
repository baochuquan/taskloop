require 'json'
require_relative '../dsl/dsl'

module TaskLoop
  class Deploy < Command
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

      generate_taskfile_lock
    end

    #################################
    # Register taskfile dir if needed
    #################################
    private def register_taskfile_dir_if_needed
      taskfile_dir = Dir.pwd
      json_string = File.read(taskloop_project_list_path)
      parsed_json = JSON.parse(json_string)
      # check if all the registered path
      parsed_json = check_tasklist(parsed_json)
      push_taskfile_dir_if_needed(parsed_json, taskfile_dir)
    end

    private def check_tasklist(parsed_json)
      parsed_json['paths'] = parsed_json['paths'].uniq
      parsed_json['paths'] = parsed_json['paths'].select { |path| File.exists?(path)  }
      parsed_json
    end

    private def push_taskfile_dir_if_needed(parsed_json, taskfile_dir)
      duplicate = parsed_json['paths'].select { |path| path == taskfile_dir }
      if duplicate.empty?
        puts "First time to deploy current Taskfile.".ansi.blue
        puts "Register Taskfile into taskloop.".ansi.blue
        parsed_json['paths'].push(taskfile_dir)

        File.open(taskloop_project_list_path, 'w') do |file|
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

    private def generate_taskfile_lock
      puts "Generate Taskfile.lock.".ansi.blue
      FileUtils.copy_file("Taskfile", "Taskfile.lock")
      puts "Taskfile deploy success.".ansi.blue
    end

  end
end