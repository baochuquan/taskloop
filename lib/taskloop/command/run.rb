module TaskLoop
  class Run < Command
    require_relative '../task'
    require_relative '../rules/rule'
    require_relative '../rules/loop_rule'
    require_relative '../rules/scope_rule'
    require_relative '../rules/specific_rule'

    self.abstract_command = false

    self.summary = "Execute all the registered tasks that meet their requirements."

    self.description = <<-DESC
    The `taskloop run` command will execute all the registered tasks that meet their requiremets.
    Taskloop will read all the registered Taskfiles from `~/.taskloop/tasklist.json`, then execute
    each Tasfile to figure out if there is any task need to be executed. If needed, they will be
    executed.
    DESC

    def path_tasks_map
      @path_tasks_map ||= {}
    end

    def run
      super
      construct_project_tasks_map
    end

    #################################
    # Loop Syntax
    #################################
    def every(interval)
      LoopRule.new(:unknown, interval)
    end

    #################################
    # Specific Syntax
    #################################

    # Only for year/month
    def of(value)
      SpecificRule.new(:unknown, value)
    end

    # Only for day
    def on(value)
      SpecificRule.new(:day, value)
    end

    # Only for minute/hour
    def at(value)
      SpecificRule.new(:unknown, value)
    end

    #################################
    # Scope Syntax
    #################################
    def before(right)
      BeforeScopeRule.new(:unknown, :before, right)
    end

    def between(left, right)
      BetweenScopeRule.new(:unknown, :between, left, right)
    end

    def after(left)
      AfterScopeRule.new(:unknown, :after, left)
    end

    private def construct_project_tasks_map
      # load Taskfiles from ~/.taskloop/tasklist.json
      taskfile_paths.each do |path|
        execute_taskfile(path)
      end
    end

    #################################
    # Private Methods
    #################################
    private def execute_taskfile(path)
      string = File.open(path, 'r:utf-8', &:read)
      if string.respond_to?(:encoding) && string.encoding.name != 'UTF-8'
        string.encode!('UTF-8')
      end
      eval(string)
      rescue Exception => e
        message = "Invalid `#{path}` file: #{e.message}"
        raise ArgumentError, "test"
    end
  end
end