module TaskLoop
  class Init < Command
    self.abstract_command = false

    self.summary = "Setup a project to support taskloop."

    self.description = <<-DESC
      The `taskloop init` command will create a file named Taskfile in the current directory.
      You can modify Taskfile to customize the execution rules for each scheduled task.
      Attention! You should execute this command in the root directory of your project.
    DESC

    def run
      super
      # check if Taskfile exist in current directory
      if File.exists?(:Taskfile.to_s)
        puts "Warning: Taskfile exists! There is no need to execute `taskloop init` command in current directory!".ansi.yellow
        puts ""
        return
      end

      file = File.new(:Taskfile.to_s, "w+")
      content = <<-DESC
# env to set environment variables which are shared by all tasks defined in the Taskfile. <Optional>
# env "ENV_NAME", "ENV_VALUE" 

TaskLoop::Task.new do |t|
  t.name = 'TODO: task name. <Required>'
  t.path = 'TODO: task job path. For exmaple, t.path = "./Job.sh". <Required>'
  t.year = "TODO: year rule. <Optional>"
  t.month = "TODO: month rule. <Optional>"
  t.day = "TODO: day rule. <Optional>"
  t.hour = "TODO: hour rule. <Optional>"
  t.minute = "TODO: minute rule. <Optional>"
  t.loop = "TODO: loop count. <Optional>"
end
      DESC
      file.puts content
      file.close
    end
  end
end