module Taskloop
  class Register < Command
    self.abstract_command = false

    self.summary = "Register a project into taskloop."

    self.description = <<-DESC
      The `taskloop register` command will register a project which has defined a Taskfile into taskloop.
      Taskloop will record this information in ~/.taskloop/config.
    DESC

    def run
      super
      createTaskloopDirIfNeeded
      createTaskListIfNeeded
    end
  end
end