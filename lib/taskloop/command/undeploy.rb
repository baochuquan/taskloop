module TaskLoop
  class Undeploy < Command
    self.abstract_command = false

    self.summary = "Check Taskfile..."

    self.description = <<-DESC
    TODO baocq
    DESC

    def run
      super
      puts "taskloop list...Taskloop List"
    end
  end
end