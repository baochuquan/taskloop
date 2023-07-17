module TaskLoop
  class Run < Command
    include TaskLoop::DSL

    require_relative '../task/task'
    require_relative '../rules/rule'
    require_relative '../rules/interval_rule'
    require_relative '../rules/scope_rule'
    require_relative '../rules/default_rule'
    require_relative '../rules/specific_rule'
    require_relative '../rules/after_scope_rule'
    require_relative '../rules/before_scope_rule'
    require_relative '../rules/between_scope_rule'
    require_relative '../extension/string_extension'
    require_relative '../extension/integer_extension'

    require 'open3'

    self.abstract_command = false

    self.summary = "Execute all the registered tasks that meet their requirements."

    self.description = <<-DESC
    The `taskloop run` command will execute all the registered tasks that meet their requiremets.
    Taskloop will read all the registered Taskfiles from `~/.taskloop/tasklist.json`, then execute
    each Tasfile to figure out if there is any task need to be executed. If needed, they will be
    executed.
    DESC

    attr_reader :proj_tasklist_map

    def proj_tasklist_map
      @proj_tasklist_map ||= {}
    end

    #################################
    # Utils Methods
    #################################

    def run
      super
      construct_proj_tasklist_map
      construct_proj_tasklist_cache
      execute_tasks_if_needed
      clean_cache_file_if_needed
    end

    private def construct_proj_tasklist_map
      # load Taskfiles from ~/.taskloop/tasklist.json
      taskfile_dirs.each do |dir|
        lock_file_path = dir + "/Taskfile.lock"
        eval_taskfile(lock_file_path)
        proj_tasklist_map[dir] = TaskLoop::Task.tasklist
        TaskLoop::Task.tasklist = []
      end
    end

    private def eval_taskfile(path)
      string = File.open(path, 'r:utf-8', &:read)
      if string.respond_to?(:encoding) && string.encoding.name != 'UTF-8'
        string.encode!('UTF-8')
      end
      eval(string)
      rescue Exception => e
        message = "Invalid `#{path}` file: #{e.message}"
        # TODO: @baocq
        raise ArgumentError, "test"
    end

    private def construct_proj_tasklist_cache
      unless @proj_tasklist_map != nil
        return
      end
      @proj_tasklist_map.each do |proj, list|
        proj_cache_dir = File.join(taskloop_cache_dir, [proj.sha1_8bit])
        create_dir_if_needed(proj_cache_dir)

        list.each do |task|
          # set properties for task
          task.proj_cache_dir = proj_cache_dir
          task.taskfile_path = File.join(proj, "Taskfile")
          task.taskfile_lock_path = File.join(proj, "Taskfile.lock")

          task_cache_time_path = File.join(proj_cache_dir, task.timefile_name)
          unless File.file?(task_cache_time_path)
            file = File.new(task_cache_time_path, "w+")
            file.puts "0"
            file.close
          end

          task_cache_log_path = File.join(proj_cache_dir, task.logfile_name)
          unless File.file?(task_cache_log_path)
            File.new(task_cache_log_path, "w+")
          end

          task_cache_loop_path = File.join(proj_cache_dir, task.loopfile_name)
          unless File.file?(task_cache_loop_path)
            File.new(task_cache_loop_path, "w+")
          end
        end
      end
    end

    private def execute_tasks_if_needed
      unless @proj_tasklist_map != nil
        return
      end

      @proj_tasklist_map.each do |proj, list|
        list.each do |task|
          unless task.check_rule_conflict?
            puts "task<#{task.sha1}> is rule conflict, skip..."
            next
          end
          if task.check_all_rules?
            execute_task(proj, task)
          end
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

      cmd = path
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        # record execute information into task's logfile
        out = stdout.read
        err = stderr.read
        content = out + "\n" + err
        task.write_to_logfile(content)
      end
    end

    private def clean_cache_file_if_needed
      unless @proj_tasklist_map != nil
        return
      end

      @proj_tasklist_map.each do |proj, list|
        proj_cache_dir = File.join(taskloop_cache_dir, [proj.sha1_8bit])
        files = Dir.entries(proj_cache_dir)

        list.each do |task|
          files.delete(task.logfile_name)
          files.delete(task.timefile_name)
        end

        files.each do |file|
          path = File.join(proj_cache_dir, file)
          if file != '.' and file != '..' and File.exists?(path)
            File.delete(path)
          end
        end
      end
    end
  end
end