module Taskloop
  require 'claide'

  class Command < CLAide::Command

    require 'taskloop/command/init'
    require 'taskloop/command/lint'
    require 'taskloop/command/list'
    require 'taskloop/command/log'
    require 'taskloop/command/register'
    require 'taskloop/command/unregister'

    self.abstract_command = true

    self.description = 'Taskloop Command Description.'

    self.command = 'taskloop'

    # def self.options
    #   [
    #     ['--verbose', 'Show detail information while executing command.']
    #   ].concat(super)
    # end

    def initialize(argv)
      # @verbose = argv.flag?('verbose', true)
      super
    end

    def run

    end

    def createTaskloopDirIfNeeded
      # create ~/.taskloop directory if needed.
      user_dir = Dir.home
      taskloop_dir = File.join(user_dir, ".taskloop")
      unless File.directory?(taskloop_dir)
        FileUtils.mkdir(taskloop_dir)
      end
    end

    def createTaskListIfNeeded
      # create ~/.taskloop/tasklist.json directory if needed.
      user_dir = Dir.home
      tasklist = File.join(user_dir, ".taskloop", "tasklist.json")
      unless  File.file?(tasklist)
        file = File.new(tasklist, "w+")
        content = <<-DESC
{
   "path": [],
   "git": []
}
        DESC
        file.puts content
        file.close
      end
    end
  end
end