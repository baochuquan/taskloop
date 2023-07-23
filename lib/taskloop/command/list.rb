require_relative '../utils/proj_tasklist'

module TaskLoop
  class List < Command

    include TaskLoop::ProjTaskList

    self.abstract_command = false

    self.summary = "List current running tasks in taskloop."

    self.description = <<-DESC
      The 'taskloop list' command will list all the running tasks in taskloop.
    DESC

    attr_reader :proj_tasklist_map

    def proj_tasklist_map
      @proj_tasklist_map ||= {}
    end

    def run
      super
      construct_proj_tasklist_map
    end
  end
end