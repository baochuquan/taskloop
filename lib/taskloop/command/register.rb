module Taskloop
  class Register < Command
    self.abstract_command = true

    self.summary = "Check Taskfile..."

    self.description = <<-DESC
    TODO baocq
    DESC

    def run
      super
      puts "taskloop register...Taskloop Register"
    end
  end
end