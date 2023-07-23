
module TaskLoop
  module ProjTaskList
    attr_reader :proj_tasklist_map

    def proj_tasklist_map
      @proj_tasklist_map ||= {}
    end

    def create_data_proj_dir_if_needed
      taskloop_proj_list_dirs.each do |dir|
        # create ~/.tasklooop/data/<proj-sha1-8bit>/ dir
        data_proj_dir = File.join(taskloop_data_dir, dir.sha1_8bit)
        create_dir_if_needed(data_proj_dir)
      end
    end

    def create_data_proj_description_if_needed
      taskloop_proj_list_dirs.each do |dir|
        # create ~/.taskloop/data/<proj_sha1-8bit>/.description
        data_proj_description_path = File.join(taskloop_data_dir, dir.sha1_8bit, ".description")
        unless File.exists?(data_proj_description_path)
          desc = File.new(data_proj_description_path, "w+")
          desc.puts dir
          desc.close
        end
      end
    end


    def construct_proj_tasklist_map
      # load Taskfiles from ~/.taskloop/projlist
      taskloop_proj_list_dirs.each do |dir|
        deploy_file_path = File.join(taskloop_data_dir, dir.sha1_8bit,".Taskfile.deploy")
        unless File.exists?(deploy_file_path)
          puts "Warning: #{deploy_file_path} is not exist, taskloop will skip its execution.".ansi.yellow
          proj_tasklist_map[dir] = []
          next
        end
        eval_taskfile(deploy_file_path)
        proj_tasklist_map[dir] = TaskLoop::Task.tasklist
        TaskLoop::Task.tasklist = []
      end
    end

    private def setup_task_property
      unless @proj_tasklist_map != nil
        return
      end
      @proj_tasklist_map.each do |proj, list|
        list.each do |task|
          data_proj_dir = File.join(taskloop_data_dir, proj.sha1_8bit)
          # set properties for task
          task.data_proj_dir = data_proj_dir
        end
      end
    end

    private def create_data_proj_task_log_if_needed
      unless @proj_tasklist_map != nil
        return
      end
      @proj_tasklist_map.each do |proj, list|
        list.each do |task|
          data_proj_dir = File.join(taskloop_data_dir, proj.sha1_8bit)

          task_cache_log_path = File.join(data_proj_dir, task.logfile_name)
          unless File.file?(task_cache_log_path)
            File.new(task_cache_log_path, "w+")
          end
        end
      end
    end

    private def create_data_proj_task_time_if_needed
      unless @proj_tasklist_map != nil
        return
      end
      @proj_tasklist_map.each do |proj, list|
        list.each do |task|
          data_proj_dir = File.join(taskloop_data_dir, proj.sha1_8bit)

          task_cache_time_path = File.join(data_proj_dir, task.timefile_name)
          unless File.file?(task_cache_time_path)
            file = File.new(task_cache_time_path, "w+")
            file.puts "0"
            file.close
          end
        end
      end
    end

    private def create_data_proj_task_loop_if_needed
      unless @proj_tasklist_map != nil
        return
      end
      @proj_tasklist_map.each do |proj, list|
        list.each do |task|
          data_proj_dir = File.join(taskloop_data_dir, proj.sha1_8bit)

          task_cache_loop_path = File.join(data_proj_dir, task.loopfile_name)
          unless File.file?(task_cache_loop_path)
            File.new(task_cache_loop_path, "w+")
          end
        end
      end
    end

    def eval_taskfile(path)
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

    def clean_cache_file_if_needed
      unless @proj_tasklist_map != nil
        return
      end

      @proj_tasklist_map.each do |proj, list|
        data_proj_dir = File.join(taskloop_data_dir, proj.sha1_8bit)
        files = Dir.entries(data_proj_dir)

        list.each do |task|
          files.delete(task.logfile_name)
          files.delete(task.timefile_name)
        end

        files.each do |file|
          path = File.join(data_proj_dir, file)
          if file != '.' && file != '..' && file != '.Taskfile.deploy' && file != '.description' && File.exists?(path)
            File.delete(path)
          end
        end
      end
    end
  end
end
