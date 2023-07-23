
module TaskLoop
  module ProjTaskList
    attr_reader :proj_tasklist_map

    def proj_tasklist_map
      @proj_tasklist_map ||= {}
    end

    def create_data_proj_file_structure_if_needed
      taskloop_proj_list_dirs.each do |dir|
        # create ~/.tasklooop/data/<proj-sha1-8bit>/ dir
        data_proj_dir = File.join(taskloop_data_dir, dir.sha1_8bit)
        create_dir_if_needed(data_proj_dir)

        # create ~/.taskloop/data/<proj_sha1-8bit>/.description
        data_proj_description_path = File.join(data_proj_dir, ".description")
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

  end
end
