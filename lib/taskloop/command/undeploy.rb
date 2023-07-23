require 'fileutils'

module TaskLoop
  class Undeploy < Command
    self.abstract_command = false

    self.summary = "Undeploy a Taskfile from taskloop."

    self.description = <<-DESC
    The "taskloop undeploy" command will undeploy a Taskfile from taskloop. It should be executed in the directory where 
    Taskfile exists.
    DESC

    def run
      super
      unless File.exists?(:Taskfile.to_s)
        puts "Error: 'taskloop undeploy' command should be executed in the directory where Taskfile exists.".ansi.red
        return
      end

      remove_proj_path_from_projlist
    end

    def remove_proj_path_from_projlist
      current_dir = Dir.pwd
      proj_list_dirs = taskloop_proj_list_dirs
      unless proj_list_dirs.include?(current_dir)
        puts "Warning: current Taskfile is not deployed before. Do not need to undeploy it again.".ansi.yellow
        return
      end
      proj_list_dirs.delete(current_dir)
      File.open(taskloop_proj_list_path, "w") do |file|
        file.write(JSON.pretty_generate(proj_list_dirs))
      end

      data_proj_dir = File.join(taskloop_data_dir, current_dir.sha1_8bit)
      unless File.directory?(data_proj_dir)
        puts "Warning: #{data_proj_dir} not exist. ".ansi.yellow
        return
      end

      FileUtils.rm_rf(data_proj_dir)
      puts "Taskfile in <#{current_dir}> has been undeployed successfully.".ansi.blue
    end
  end
end