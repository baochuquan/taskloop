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

    def initialize
      yield self
      check = true
      unless @name
        puts "Error: task name is required.".ansi.red
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
          puts "Error: #{task.desc} => there are multiple tasks with the same name in the Taskfile. Please check the task name again.".ansi.red
          result = false
        end
        # only check with the task before self
        if task == self
          break
        end
      end
      # check if task path exists
      unless @path && File.exists?(@path)
        puts "Error: #{desc} => the file in <#{@path}> is not exist. Please check the task path again.".ansi.red
        result = false
      end
      # check task rules conflict
      unless check_rule_conflict?
        puts "Error: #{desc} rule conflicts have been detected above.".ansi.red
        result = false
      end
      unless result
        puts "=============================".ansi.red
      end
      return result
    end

    def check_rule_conflict?
      result = true
      # check year/month/day with date, they cannot be set at the same time
      if has_ymd? && has_date?
        puts "Error: #{desc} => <year/month/day> and <date> cannot be set at the same time.".ansi.red
        result = false
      end

      # check hour/minute with time, they cannot be set at the same time
      if has_hm? && has_time?
        puts "Error: #{desc} => <hour/minute> and <time> cannot be set at the same time.".ansi.red
        result = false
      end

      # check rule type

      if has_ymd? && has_hm?
        # check minute/hour/day/month/year. Get the last IntervalRule, than check if there is SpecificRule or ScopeRule before
        rules = [minute, hour, day, month, year]
        rIdx = rules.rindex { |rule| rule.is_a?(IntervalRule) }
        if rIdx != nil
          rules.each_with_index do |rule, index|
            if index < rIdx && (rule.is_a?(ScopeRule) || rule.is_a?(SpecificRule))
              puts "Error: #{desc} => a ScopeRule or a SpecificRule is assigned to a smaller unit while a IntervalRule is assigned to a larger unit.".ansi.red
              result = false
              break
            end
          end

        end


      end

      if has_ymd? && has_time?
        # check year/month/day with time, YMD can not have IntervalRule
        rules = [day, month, year]
        hasInterval = rules.any? { |rule| rule.is_a?(IntervalRule) }
        if hasInterval
          puts "Error: #{desc} => a IntervalRule is assigned to <year/month/day> while <time> is assigned. It is a conflict!".ansi.red
          result = false
        end
      end

      if has_date? && has_hm?
        # it's ok
      end

      if has_date? && has_time?
        # it's ok
      end

      return result
    end

    def check_all_rules?
      last_exec_time = last_time

      result = true
      result &&= check_boundary_rule?(last_exec_time)
      result &&= check_interval_rule?(last_exec_time)
      result &&= check_scope_rule?(last_exec_time)
      result &&= check_specific_fule?(last_exec_time)
      result &&= check_loop_rule?(last_exec_time)
      return result
    end

    private def check_interval_rule?(last_exec_time)
      result = true
      min = 0
      if year.is_a?(IntervalRule)
        min += year.interval * YEAR_MIN
      end
      if month.is_a?(IntervalRule)
        min += month.interval * MONTH_MIN
      end
      if day.is_a?(IntervalRule)
        min += day.interval * DAY_MIN
      end
      if hour.is_a?(IntervalRule)
        min += hour.interval * HOUR_MIN
      end
      if minute.is_a?(IntervalRule)
        min += minute.interval
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
      if week.is_a?(ScopeRule)
        result &&= week.is_conform_rule?(last_exec_time)
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
      if week.is_a?(SpecificRule)
        result &&= week.is_conform_rule?(last_exec_time)
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
      count = loop_count

      result = true
      if loop.is_a?(LoopRule)
        result = count < loop.count
      end
      return result
    end

    private def check_boundary_rule?(last_exec_time)
      result = true
      result &&= start_point.is_conform_rule?(last_exec_time)
      result &&= end_point.is_conform_rule?(last_exec_time)
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
      "<Task.name: #{@name}, sha1: #{sha1}>"
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
