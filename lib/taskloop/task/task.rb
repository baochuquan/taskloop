module TaskLoop
  class Task
    require 'digest'
    require 'taskloop/extension/string_extension'
    require 'taskloop/extension/integer_extension'
    require_relative './task_error'
    require_relative './task_property'
    require_relative './task_data_file'

    include TaskLoop::TaskProperty
    include TaskLoop::TaskDataFile

    @@tasklist = []
    def self.tasklist
      @@tasklist
    end

    def self.tasklist=(value)
      @@tasklist = value
    end

    def initialize()
      yield self
      check = true
      unless @name
        puts "Error: task name is reqired.".ansi.red
        puts ""
        check = false
      end
      unless @path
        puts "Error: task path is required.".ansi.red
        puts ""
        check = false
      end
      unless check
        raise TaskArgumentError, "Lack of <required> arguments."
      end
      @@tasklist.push(self)
    end

    #################################
    # Check and Lint
    #################################
    def deploy_lint?
      result = true
      # task name
      @@tasklist.each { |task|
        if task != self && task.name == @name
          puts "Error: task name `#{@name}` duplicated with in Taskfile. Every task name should be unique in a Taskfile.".ansi.red
          puts ""
          result = false
        end
        # only check with the task before self
        if task == self
          break
        end
      }
      # task path
      unless @path && File.exists?(@path)
        puts "Error: task path `#{@path}` specified file must be exit. Please check the task path again.".ansi.red
        puts ""
        result = false
      end
      # task rule
      unless check_rule_conflict?
        puts "Error: the rules of the task may conflict. Please check the rules again.".ansi.red
        puts "Suggestion: SpecificRule and ScopeRule cannot execute during IntervalRules.".and.red
        puts ""
        result = false
      end
      return result
    end

    def check_rule_conflict?
      puts "Check rule conflict ...".ansi.blue
      result = true
      rules = [minute, hour, day, month, year]
      rIdx = rules.rindex { |rule| rule.is_a?(IntervalRule) }
      unless rIdx != nil
        return result
      end

      rules.each_with_index do |rule, index|
        if index < rIdx && (rule.is_a?(ScopeRule) || rule.is_a?(SpecificRule))
          result = false
        end
      end
      if result
        puts "<Task.name: #{@name}> rule check success.".ansi.blue
      else
        puts "<Task.name: #{@name}> rule check failed.".ansi.red
      end
      return result
    end

    def check_all_rules?
      timestamp = 0
      File.open(timefile_path, 'r') do |file|
        timestamp = file.gets.to_i
      end
      last_exec_time = Time.at(timestamp)
      conform = true
      if has_interval_rule?
        puts "#{desc} has interval rule.".ansi.blue
        conform = check_for_interval_rule?(last_exec_time)
      else
        puts "#{desc} no interval rule."
        conform &&= year.is_conform_rule?(last_exec_time)
        conform &&= month.is_conform_rule?(last_exec_time)
        conform &&= day.is_conform_rule?(last_exec_time)
        conform &&= hour.is_conform_rule?(last_exec_time)
        conform &&= minute.is_conform_rule?(last_exec_time)
      end
      puts "#{desc} check all rule: #{conform}".ansi.blue
      return conform
    end

    private def has_interval_rule?
      rules = [year, month, day, hour, minute]
      return rules.any?{ |rule| rule.is_a?(IntervalRule) }
    end

    private def check_for_interval_rule?(last_exec_time)
      result = true
      min = 0
      if year.is_a?(IntervalRule)
        min += year.interval * YEAR_MIN
      else
        result &&= year.is_conform_rule?(last_exec_time)
      end
      if month.is_a?(IntervalRule)
        min += month.interval * MONTH_MIN
      else
        result &&= month.is_conform_rule?(last_exec_time)
      end
      if day.is_a?(IntervalRule)
        min += day.interval * DAY_MIN
      else
        result &&= day.is_conform_rule?(last_exec_time)
      end
      if hour.is_a?(IntervalRule)
        min += hour.interval * HOUR_MIN
      else
        result &&= hour.is_conform_rule?(last_exec_time)
      end
      if minute.is_a?(IntervalRule)
        min += minute.interval
      else
        result &&= minute.is_conform_rule?(last_exec_time)
      end
      correction = 20
      result &&= (Time.now.to_i - last_exec_time.to_i + correction) / 60.0 >= min
      return result
    end
    
    #################################
    # Sha1 and description
    #################################
    def sha1
      sha1_digest = Digest::SHA1.new
      sha1_digest.update(@name)
      return sha1_digest.hexdigest
    end

    def desc
      "<Task.name: #{@name}>"
    end

    #################################
    # Time Seconds
    #################################

    YEAR_MIN = 365 * 24 * 60

    MONTH_MIN = 30 * 24 * 60

    DAY_MIN = 24 * 60

    HOUR_MIN = 60
  end
end
