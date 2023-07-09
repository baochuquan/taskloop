module TaskLoop
  class Lint < Command
    self.abstract_command = false

    self.summary = "Check Taskfile..."

    self.description = <<-DESC
    TODO baocq
    DESC
    def run
      super
      puts "taskloop lint...Taskloop Lint"
    end
  end
end