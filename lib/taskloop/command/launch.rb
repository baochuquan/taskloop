module TaskLoop
  class Launch < Command
    self.abstract_command = false

    self.summary = "Check Taskfile..."

    self.description = <<-DESC
    TODO baocq
    DESC
    def run
      super
      puts "taskloop launch"
    end
  end
end