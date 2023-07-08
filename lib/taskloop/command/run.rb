module Taskloop
  class Run < Command
    self.abstract_command = false

    self.summary = "Execute all the registered tasks that meet their requirements."

    self.description = <<-DESC
    The `taskloop run` command will execute all the registered tasks that meet their requiremets.
    Taskloop will read all the registered Taskfiles from `~/.taskloop/tasklist.json`, then execute
    each Tasfile to figure out if there is any task need to be executed. If needed, they will be
    executed.
    DESC

    def path_tasks_map
      @path_tasks_map ||= {}
    end

    def run
      super
      construct_project_tasks_map
    end

    private def construct_project_tasks_map
      # load Taskfiles from ~/.taskloop/tasklist.json
      taskfile_paths.each do |path|
        execute_taskfile(path)
      end
    end

    private def execute_taskfile(path)
      string = File.open(path, 'r:utf-8', &:read)
      if string.respond_to?(:encoding) && string.encoding.name != 'UTF-8'
        string.encode!('UTF-8')
      end
      task = eval(string)
      puts task.hash
    end
  end
end