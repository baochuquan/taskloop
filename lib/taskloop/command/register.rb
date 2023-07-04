require 'json'

module Taskloop
  class Register < Command
    self.abstract_command = false

    self.summary = "Register a project into taskloop."

    self.description = <<-DESC
      The `taskloop register` command will register a project which has defined a Taskfile into taskloop.
      Taskloop will record this information in ~/.taskloop/tasklist.json.
    DESC

    def run
      super
      # check if Taskfile exist
      unless  File.file?(:Taskfile.to_s)
        puts "Taskfile is not exist. Please goto the project's root directory and execute again, or run `taskloop init` command first if current directory is the root directory of a project.".ansi.red
        exit 1
      end

      # TODO: @baocq lint Taskfile if needed

      # create ~/.taskloop/
      createTaskloopDirIfNeeded
      # create ~/.taskloop/tasklist.json
      createTaskListIfNeeded
      # register current Taskfile path into taslist.json
      registerTaskfile
    end

    private def registerTaskfile
      taskfile_path = Dir.pwd + "/Taskfile"
      tasklist = File.join(Dir.home, ".taskloop", "tasklist.json")
      json_string = File.read(tasklist)
      parsed_json = JSON.parse(json_string)
      # check if all the registered path
      parsed_json = checkTasklist(parsed_json)
      # add current Tasfile
      parsed_json = pushTaskFileIfNeeded(parsed_json, taskfile_path)

      # write back
      File.open(tasklist, 'w') do |file|
        file.write(JSON.pretty_generate(parsed_json))
      end
    end

    private def checkTasklist(parsed_json)
      parsed_json['path'] = parsed_json['path'].uniq
      parsed_json['path'] = parsed_json['path'].select { |path| File.exists?(path)  }
      parsed_json
    end

    private def pushTaskFileIfNeeded(parsed_json, taskfile_path)
      duplicate = parsed_json['path'].select { |path| path == taskfile_path }
      if duplicate.empty?
        parsed_json['path'].push(taskfile_path)
      end
      parsed_json
    end
  end
end