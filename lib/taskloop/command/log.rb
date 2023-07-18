module TaskLoop
  class Log < Command
    self.abstract_command = false

    self.summary = "Check log"

    self.description = <<-DESC
    TODO baocq
    DESC

    def self.options
      [
        ['--task-name=TASK_NAME', "To show the log of a task specified by option."],
        ['--cron', 'To show the log of taskloop, which is based on cron.'],
      ].concat(super)
    end

    def initialize(argv)
      @task_name = argv.option('task-name')
      @cron = argv.flag?('cron', false)
      super
    end

    def validate!
      super
      if @task_name && @cron
        help! "The --task-name option and the --cron option cannot be used simultaneously."
      end

      if @task_name == nil && !@cron
        help! "Use --task-name option or --cron option for 'taskloop log' command."
      end
    end

    def run
      super
      if @task_name
        check_log_of_task(@task_name)
        return
      end

      if @cron
        check_log_of_cron
        return
      end
    end

    def check_log_of_task(name)
      proj_cache_dirs = Dir.entries(taskloop_cache_dir)
      proj_cache_dirs.each do |dir|
        if dir == "." or dir == ".."
          next
        end

        found = false
        proj_cache_dir = File.join(taskloop_cache_dir, dir)
        log_files = Dir.entries(proj_cache_dir)
        log_files.each do |file|
          if "#{name.sha1}_log" == file
            found = true
            task_path = File.join(proj_cache_dir, "#{name.sha1}_log")
            puts "=============================".ansi.blue
            puts "Log of <Task.name: #{name}>: ".ansi.blue
            File.open(task_path).each_line do |line|
              puts line
            end
            puts "=============================".ansi.blue
            puts ""
          end
        end

        unless found
          puts "Warning: log of <Task.name: #{name}> not exist. Please check if the name of task is correct.".ansi.yellow
          puts ""
        end
      end
    end

    def check_log_of_cron
      puts "=============================".ansi.blue
      puts "Log of cron: ".ansi.blue
      puts ""
      log_file = File.open(taskloop_cron_log_path, "r")
      log_file.each_line do |line|
        puts line
      end
      puts "=============================".ansi.blue
      puts ""
    end
  end
end