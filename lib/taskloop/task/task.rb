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
      # check task name uniqueness
      @@tasklist.each do |task|
        if task != self && task.name == @name
          puts "Error: task name `#{@name}` duplicated with in Taskfile. Every task name should be unique in a Taskfile.".ansi.red
          puts ""
          result = false
        end
        # only check with the task before self
        if task == self
          break
        end
        end
      # check if task path exists
      unless @path && File.exists?(@path)
        puts "Error: task path `#{@path}` specified file must be exit. Please check the task path again.".ansi.red
        puts ""
        result = false
      end
      # check task rules conflict
      unless check_rule_conflict?
        puts "Error: the rules of the task may conflict. Please check the rules again.".ansi.red
        puts "Suggestion: SpecificRule and ScopeRule cannot execute during IntervalRules.".and.red
        puts ""
        result = false
      end
      return result
    end

    def check_rule_conflict?
      result = true
      # check year/month/day with date, they cannot be set at the same time
      if hasYMD && hasDate
        result = false
      end

      # check hour/minute with time, they cannot be set at the same time
      if hasHM && hasDate
        result = false
      end

      # check rule type

      if hasYMD && hasHM
        # check minute/hour/day/month/year. Get the last IntervalRule, than check if there is SpecificRule or ScopeRule before
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
      end

      if hasYMD && hasTime
        # check year/month/day with time, YMD can not have IntervalRule
        rules = [day, month, year]
        hasInterval = rules.any? { |rule| rule.is_a?(IntervalRule) }
        if hasInterval
          result = false
        end
      end

      if hasDate && hasHM
        # it's ok
      end

      if hasDate && hasTime
        # it's ok
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
        conform = check_interval_rule?(last_exec_time)
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

    private def check_interval_rule?(last_exec_time)
      result = true
      min = 0
      if year.is_a?(IntervalRule)
        min += year.interval * YEAR_MIN
      # else
      #   result &&= year.is_conform_rule?(last_exec_time)
      end
      if month.is_a?(IntervalRule)
        min += month.interval * MONTH_MIN
      # else
      #   result &&= month.is_conform_rule?(last_exec_time)
      end
      if day.is_a?(IntervalRule)
        min += day.interval * DAY_MIN
      # else
      #   result &&= day.is_conform_rule?(last_exec_time)
      end
      if hour.is_a?(IntervalRule)
        min += hour.interval * HOUR_MIN
      # else
      #   result &&= hour.is_conform_rule?(last_exec_time)
      end
      if minute.is_a?(IntervalRule)
        min += minute.interval
      # else
      #   result &&= minute.is_conform_rule?(last_exec_time)
      end
      correction = 20
      result &&= (Time.now.to_i - last_exec_time.to_i + correction) / 60.0 >= min
      return result
    end

    private def check_scope_rule?(last_exec_time)
      result = true
      if year.is_a?(ScopeRule)
        result &&= year.is_conform_rule?(last_exec_time)
      end
      if month.is_a?(ScopeRule)
        result &&= month.is_conform_rule?(last_exec_time)
      end
      if day.is_a?(ScopeRule)
        result &&= day.is_conform_rule?(last_exec_time)
      end
      if hour.is_a?(ScopeRule)
        result &&= hour.is_conform_rule?(last_exec_time)
      end
      if minute.is_a?(ScopeRule)
        result &&= minute.is_conform_rule?(last_exec_time)
      end
      return result
    end

    private def check_specific_fule?(last_exec_time)
      result = true
      if year.is_a?(SpecificRule)
        result &&= year.is_conform_rule?(last_exec_time)
      end
      if month.is_a?(SpecificRule)
        result &&= month.is_conform_rule?(last_exec_time)
      end
      if day.is_a?(SpecificRule)
        result &&= day.is_conform_rule?(last_exec_time)
      end
      if hour.is_a?(SpecificRule)
        result &&= hour.is_conform_rule?(last_exec_time)
      end
      if minute.is_a?(SpecificRule)
        result &&= minute.is_conform_rule?(last_exec_time)
      end
      if time.is_a?(TimeListRule)
        result &&= time.is_conform_rule?(last_exec_time)
      end
      if date.is_a?(DateListRule)
        result &&= time.is_conform_rule?(last_exec_time)
      end
      return result
    end

    private def check_loop_rule?(last_exec_time)
      count = 0
      File.open(loopfile_path, 'r') do |file|
        count = file.gets.to_i
      end

      result = true
      if !loop.is_a?(LoopRule)
        result = count < loop.count
      end
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
