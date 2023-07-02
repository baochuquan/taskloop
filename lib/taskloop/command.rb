module Taskloop
  require 'claide'

  class Command < CLAide::Command

    self.abstract_command = true

    self.description = 'Taskloop Command Description.'

    self.command = 'taskloop'

    def self.options
      [
        ['--verbose', 'Show detail information while executing command.']
      ].concat(super)
    end

    def initialize(argv)
      @verbose = argv.flag?('verbose', true)
      super
    end

    def run
      puts "run ... Taskloop Command"
    end
  end
end