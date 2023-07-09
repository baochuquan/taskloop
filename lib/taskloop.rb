# frozen_string_literal: true

require_relative "taskloop/version"

module TaskLoop
  class Error < StandardError; end
  # Your code goes here...
  autoload :Command, 'taskloop/command'
end
