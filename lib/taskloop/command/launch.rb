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
    end

    def create_run_control_file_if_needed
      unless File.exists?(tasklooprc_path)
        rc = File.new(tasklooprc_path, "w+")
        variables = ["PATH", "RUBY_VERSION", "GEM_PATH", "GEM_HOME", "IRBRC"]
        variables.each do |var|
          rc.puts "export " + var + "=#{ENV[var]}"
        end
        rc.puts "taskloop run > ~/.taskloop/cron.log 2>&1"
        rc.close
      end
    end
  end
end