module Taskloop
  class Unregister < Command
    self.abstract_command = true

    self.summary = "Check Taskfile..."

    self.description = <<-DESC
    TODO baocq
    DESC

    def run
      super
      puts "taskloop register...Taskloop Unregister"
    end
  end
end