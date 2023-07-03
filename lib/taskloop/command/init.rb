module Taskloop
  class Init < Command
    self.abstract_command = false

    self.summary = "setup a project to support taskloop."

    self.description = <<-DESC
      The `taskloop init` command will create a file named Taskfile in the current directory.
      You can modify Taskfile to customize the execution rules for each scheduled task.
      Attention! You should execute this command in the root directory of your project.
    DESC

    def run
      super
      # check if Taskfile exist in current directory
      if File.exists?(:Taskfile.to_s)
        puts "Taskfile exists! There is no need to execute `taskloop init` command in current directory!".ansi.red
        return
      end

      taskfile = File.new(:Taskfile.to_s, "w+")
      # TODO: @baocq 注入模板代码
      taskfile.puts("debug")
      taskfile.close
    end
  end
end