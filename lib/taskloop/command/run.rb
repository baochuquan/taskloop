module Taskloop
  class Run < Command
    self.abstract_command = false

    self.summary = "Execute all the registered tasks that meet their requirements."

    self.description = <<-DESC
    The `taskloop run` command will execute all the registered tasks that meet their requiremets.
    Taskloop will read all the registered Taskfiles from `~/.taskloop/tasklist.json`, then execute 
    each Tasfile to figure out if there is any task need to be executed. If needed, they will be 
    executed.
    DESC

    def initialize(argv)
      super

      @tasklist =
    end

    def run
      super
      puts "taskloop run...Taskloop Run"
    end

    def
  end
end