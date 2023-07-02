module Taskloop
  class Init < Command
    self.abstract_command = true

    self.summary = "setup a project to support taskloop."

    self.description = <<-DESC
      taskloop init will create a template Taskfile in the root folder of a project. 
      You should modify Taskfile to define your own rules for every scheduled task.
    DESC

    def run
      super
      puts "taskloop init...Taskloop Init"
    end
  end
end