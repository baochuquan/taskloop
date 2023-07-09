module TaskLoop
  class Shutdown < Command
    self.abstract_command = false

    self.summary = "Check Taskfile..."

    self.description = <<-DESC
    TODO baocq
    DESC
    def run
      super
      puts "taskloop shutdown"
    end
  end
end