require_relative '../utils/proj_tasklist'
require_relative '../dsl/dsl'

module TaskLoop
  class List < Command
    include TaskLoop::DSL
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
      create_data_proj_dir_if_needed
      create_data_proj_description_if_needed

      setup_task_property

      construct_proj_tasklist_map

      show_proj_tasklist_info
    end

    def show_proj_tasklist_info
      unless @proj_tasklist_map != nil
        return
      end
      @proj_tasklist_map.each do |proj, list|
        unless list.length > 0
          next
        end
        puts "=============================".ansi.blue
        puts "Tasks above are defined in Taskfile of <#{proj}>".ansi.blue
        list.each do |task|
          puts "  #{task.desc}".ansi.blue
          puts "    t.name   = #{task.name}".ansi.blue
          puts "    t.path   = #{task.path}".ansi.blue
          puts "    t.year   = #{task.year.desc}".ansi.blue
          puts "    t.month  = #{task.month.desc}".ansi.blue
          puts "    t.day    = #{task.day.desc}".ansi.blue
          puts "    t.hour   = #{task.hour.desc}".ansi.blue
          puts "    t.minute = #{task.minute.desc}".ansi.blue
          puts "    t.loop   = #{task.loop.desc}".ansi.blue
        end
      end
    end
  end
end