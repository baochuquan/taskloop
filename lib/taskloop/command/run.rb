module Taskloop
  class Run < Command
    self.abstract_command = true

    self.summary = "Check Taskfile..."

    self.description = <<-DESC
    TODO baocq
    DESC

    def run
      super
      puts "taskloop run...Taskloop Run"
    end
  end
end