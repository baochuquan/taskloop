module TaskLoop
  class Shutdown < Command
    self.abstract_command = false

    self.summary = "Shutdown taskloop. "

    self.description = <<-DESC
    The `taskloop shutdown` command will shutdown taskloop. Therefore, every Taskfile registered in taskloop will stop. 
    It is a global switch that controls taskloop. If you execute `taskloop launch` command again after executing 'taskloop shutdown',
    every Taskfile you deployed before will resume automatically.
    DESC
    def run
      super
      unregister_taskloop_from_crontab_if_needed
    end

    def unregister_taskloop_from_crontab_if_needed
      system("crontab -l > #{taskloop_cron_tab_path}")
      registered = false
      pattern = /\A\* \* \* \* \* sh ~\/\.tasklooprc/
      remain = []
      File.open(taskloop_cron_tab_path, "r").each_line do |line|
        if line.match?(pattern)
          registered = true
        else
          remain << line
        end
      end

      unless registered
        puts "Warning: taskloop has already shutdown. Please do not shutdown again.".ansi.yellow
        puts "    If your want to launch taskloop, please execute the `taskloop launch` command.".ansi.yellow
        return
      end

      File.open(taskloop_cron_tab_path, "w") do |file|
        file.write(remain.join)
      end

      system("crontab #{taskloop_cron_tab_path}")

      puts LOGO.ansi.blue
      puts "    taskloop has shutdown successfully. ".ansi.blue
      puts ""
      puts "    byeeeeeeeeeeeeeeeee !".ansi.blue
      puts ""
    end
  end
end