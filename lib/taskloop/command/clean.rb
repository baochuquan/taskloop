module TaskLoop
  class Clean < Command
    self.abstract_command = false

    self.summary = "Check Taskfile..."

    self.description = <<-DESC
    TODO baocq
    DESC
    def run
      super
      puts "taskloop clean"
    end
  end
end