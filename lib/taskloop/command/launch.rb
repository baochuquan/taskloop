module TaskLoop
  class Launch < Command
    self.abstract_command = false

    self.summary = "Check Taskfile..."

    self.description = <<-DESC
    TODO baocq
    DESC
    def run
      super
      puts "taskloop launch"
      create_run_control_file_if_needed
      register_taskloop_into_crontab_if_needed
    end

    def create_run_control_file_if_needed
      unless File.exists?(tasklooprc_path)
        rc = File.new(tasklooprc_path, "w+")
        variables = ["PATH", "RUBY_VERSION", "GEM_PATH", "GEM_HOME", "IRBRC"]
        variables.each do |var|
          rc.puts "export " + var + "=#{ENV[var]}"
        end
        # TODO: @baocq
        rc.puts "taskloop run > ~/.taskloop/cron.log 2>&1"
        rc.close
      end
    end

    def register_taskloop_into_crontab_if_needed
      system("crontab -l > #{taskloop_cron_tab_path}")
      registered = false
      File.open(taskloop_cron_tab_path, "r").each_line do |line|
        pattern = /\A\* \* \* \* \* ~\/sh \.tasklooprc/
        if line.match?(pattern)
          registered = true
          break
        end
      end

      if registered
        puts "Warning: taskloop has already launch. Please do not launch again.".ansi.yellow
        puts "    If your want to shutdown taskloop, please execute `taskloop shutdown` command.".ansi.yellow
        return
      end

      File.open(taskloop_cron_tab_path, "a") do |file|
        file.puts "* * * * * sh ~/.tasklooprc"
      end

      system("crontab #{taskloop_cron_tab_path}")
    end
  end
end