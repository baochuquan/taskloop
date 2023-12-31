module TaskLoop
  class Launch < Command
    self.abstract_command = false

    self.summary = "Launch taskloop in order to run all the tasks which conform their rules."

    self.description = <<-DESC
    The `taskloop launch` command will register a schedule job into to crontab which is * * * * * sh ~/.tasklooprc.
    Taskloop which check all the tasks every minute. If a task met its rule, execute it.
    DESC
    def run
      super
      create_environments_file_if_needed
      create_tasklooprc_file_if_needed
      register_taskloop_into_crontab_if_needed
    end

    def create_environments_file_if_needed
      unless File.exists?(taskloop_environments_path)
        env_file = File.new(taskloop_environments_path, "w+")
        variables = ["PATH", "RUBY_VERSION", "GEM_PATH", "GEM_HOME", "IRBRC"]
        variables.each do |var|
          env_file.puts "export " + var + "=#{ENV[var]}"
        end
        env_file.close
      end
    end

    def create_tasklooprc_file_if_needed
      unless File.exists?(tasklooprc_path)
        rc = File.new(tasklooprc_path, "w+")
        rc.puts "source ~/.taskloop/environments"
        rc.puts "taskloop run > ~/.taskloop/cronlog 2>&1"
        rc.close
      end
    end

    def register_taskloop_into_crontab_if_needed
      # TODO: @baocq 考虑 crontab 为空的情况
      system("crontab -l > #{taskloop_cron_tab_path}")
      registered = false
      pattern = /\A\* \* \* \* \* sh ~\/\.tasklooprc/
      File.open(taskloop_cron_tab_path, "r").each_line do |line|
        if line.match?(pattern)
          registered = true
          break
        end
      end

      if registered
        puts "Warning: taskloop has already launched. Please do not launch again.".ansi.yellow
        puts "    If your want to shutdown taskloop, please execute the `taskloop shutdown` command.".ansi.yellow
        return
      end

      File.open(taskloop_cron_tab_path, "a") do |file|
        file.puts "* * * * * sh ~/.tasklooprc"
      end

      system("crontab #{taskloop_cron_tab_path}")

      puts LOGO.ansi.blue
      puts "    taskloop has launched successfully. ".ansi.blue
      puts ""
    end
  end
end