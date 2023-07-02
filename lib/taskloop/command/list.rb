module Taskloop
  class List < Command
    self.abstract_command = true

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