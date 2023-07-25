module TaskLoop
  class Run < Command
    require_relative '../task/task'
    require_relative '../rules/rule'
    require_relative '../rules/interval_rule'
    require_relative '../rules/scope_rule'
    require_relative '../rules/default_rule'
    require_relative '../rules/specific_rule'
    require_relative '../rules/after_scope_rule'
    require_relative '../rules/before_scope_rule'
    require_relative '../rules/between_scope_rule'
    require_relative '../rules/loop_rule'
    require_relative '../rules/date_list_rule'
    require_relative '../rules/time_list_rule'
    require_relative '../extension/string_extension'
    require_relative '../extension/integer_extension'
    require_relative '../utils/proj_tasklist'
    require_relative '../dsl/dsl'
    require 'open3'

    include TaskLoop::DSL
    include TaskLoop::ProjTaskList

    self.abstract_command = false

    self.summary = "Execute all the registered tasks that meet their requirements."

    self.description = <<-DESC
    The `taskloop run` command will execute all the registered tasks that meet their requiremets.
    Taskloop will read all the registered Taskfiles from `~/.taskloop/tasklist.json`, then execute
    each Tasfile to figure out if there is any task need to be executed. If needed, they will be
    executed.
    DESC

    #################################
    # Utils Methods
    #################################

    def run
      super
      create_data_proj_dir_if_needed
      create_data_proj_description_if_needed

      construct_proj_tasklist_map
      setup_task_property

      create_data_proj_task_log_if_needed
      create_data_proj_task_time_if_needed
      create_data_proj_task_loop_if_needed

      execute_tasks_if_needed
      clean_cache_file_if_needed
    end

    private def execute_tasks_if_needed
      unless @proj_tasklist_map != nil
        return
      end

      @proj_tasklist_map.each do |proj, list|
        list.each do |task|
          unless task.check_rule_conflict?
            puts "Warning: There is a rule conflict in #{task.desc}, taskloop will skip its execution.".ansi.yellow
            next
          end
          unless task.check_all_rules?
            puts "Checking: #{task.desc} does not meet the execution rules, taskloop will skip its execution.".ansi.blue
            next
          end
          puts "Checking: #{task.desc} doee meet the execution rules, taskloop start to execute.".ansi.blue
          execute_task(proj, task)
        end
      end
    end

    private def execute_task(proj, task)
      path = task.path
      unless path[0] == '/'
        path = File.join(proj, path)
      end

      unless File.exists?(path)
        errmsg = "No such file or directory - #{path}"
        task.write_to_logfile(errmsg)
        return
      end

      # record execute timestamp into task's timefile
      timestamp = Time.now.to_i
      task.write_to_timefile(timestamp)
      count = task.loop_count + 1
      task.write_to_loopfile(count)

      puts "Trigger Time: <#{timestamp.now}>"

      cmd = path
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        # record execute information into task's logfile
        out = stdout.read
        err = stderr.read
        content = out + "\n" + err
        task.write_to_logfile(content)
      end
    end
  end
end