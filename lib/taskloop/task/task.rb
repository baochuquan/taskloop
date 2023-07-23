module TaskLoop
  class Task
    require 'digest'
    require 'taskloop/extension/string_extension'
    require 'taskloop/extension/integer_extension'
    require_relative './task_error'

    MONTH = {
      :Jan       => 1,
      :Feb       => 2,
      :Mar       => 3,
      :Apr       => 4,
      :Jun       => 6,
      :Jul       => 7,
      :Aug       => 8,
      :Sep       => 9,
      :Oct       => 10,
      :Nov       => 11,
      :Dec       => 12,
      :mon1      => 1,
      :mon2      => 2,
      :mon3      => 3,
      :mon4      => 4,
      :mon5      => 5,
      :mon6      => 6,
      :mon7      => 7,
      :mon8      => 8,
      :mon9      => 9,
      :mon10     => 10,
      :mon11     => 11,
      :mon12     => 12,
    }

    WEEK_BASE = 10000
    WEEK = {
      :Sun       => 10000,
      :Mon       => 10001,
      :Tue       => 10002,
      :Wed       => 10003,
      :Thu       => 10004,
      :Fri       => 10005,
      :Sat       => 10006,
    }

    DAY = {
      :day1      => 1,
      :day2      => 2,
      :day3      => 3,
      :day4      => 4,
      :day5      => 5,
      :day6      => 6,
      :day7      => 7,
      :day8      => 8,
      :day9      => 9,
      :day10     => 10,
      :day11     => 11,
      :day12     => 12,
      :day13     => 13,
      :day14     => 14,
      :day15     => 15,
      :day16     => 16,
      :day17     => 17,
      :day18     => 18,
      :day19     => 19,
      :day20     => 20,
      :day21     => 21,
      :day22     => 22,
      :day23     => 23,
      :day24     => 24,
      :day25     => 25,
      :day26     => 26,
      :day27     => 27,
      :day28     => 28,
      :day29     => 29,
      :day30     => 30,
      :day31     => 31,
    }

    @@tasklist = []
    def self.tasklist
      @@tasklist
    end

    def self.tasklist=(value)
      @@tasklist = value
    end

    # the name of task
    attr_accessor :name
    # the path of task
    attr_accessor :path

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
    # Setters & Getters
    #################################
    # specific syntax
    #   - of
    #     - example: in 2024
    # interval syntax
    #   - interval
    #     - example: interval 1.year
    # scope syntax
    #   - before
    #     - example: before 2025
    #   - between
    #     - example: between 2025, 2026
    #   - after
    #     - examle: after 2023
    def year=(rule)
      unless rule.is_a?(Rule)
        raise TypeError, "the rule of year must be a class or subclass of Rule"
      end

      @year = rule
      @year.unit = :year
    end

    def year
      @year ||= DefaultRule.new(:year)
    end

    # specific syntax
    #   - of
    #     - example: of :Jan, :Feb, :Mar, :Apr, :Jun, :Jul, :Aug, :Sep, :Oct, :Nov, :Dec;
    #     - example: of :month1, :month2, :month3, ....
    # interval syntax
    #   - every
    #     - example: interval 1.month
    # scope syntax
    #   - before
    #     - example: before 2025
    #   - between
    #     - example: between 2025, 2026
    #   - after
    #     - examle: after 2023
    def month=(rule)
      unless rule.is_a?(Rule)
        raise TypeError, "the rule of month must be a class or subclass of Rule"
      end
      @month = rule
      @month.unit = :month
    end

    def month
      @month||= DefaultRule.new(:month)
    end

    # specific syntax
    #   - on
    #     - example: on :Mon, :Tue, :Wed, :Thu, :Fri, :Sat, :Sun;
    #     - example: on :day1, :day2, :day3;
    # interval syntax
    #   - interval
    #     - example: interval 10.day
    # scope syntax
    #   - before
    #     - example: before :day10
    #   - between
    #     - example: between :day10, :day19
    #     - example: between :Mon, :Fri
    #   - after
    #     - example: after :day10
    def day=(rule)
      unless rule.is_a?(Rule)
        raise TypeError, "the rule of day must be a class or subclass of Rule"
      end
      @day = rule
      @day.unit = :day
    end

    def day
      @day ||= DefaultRule.new(:day)
    end

    # specific syntax
    #   - at
    #     - example: at 10; at 23
    # interval syntax
    #   - interval
    #     - example: interval 10.hour
    # scope syntax
    #   - before
    #     - example: before 9
    #   - between
    #     - example: between 10, 12
    #   - after
    #     - example: after 11
    def hour=(rule)
      unless rule.is_a?(Rule)
        raise TypeError, "the rule of hour must be a class or subclass of Rule"
      end
      @hour = rule
      @hour.unit = :hour
    end

    def hour
      @hour ||= DefaultRule.new(:hour)
    end

    # specific syntax
    #   - at
    #     - example: at 59; at 45
    # interval syntax
    #   - interval
    #     - example: interval 5.minute
    def minute=(rule)
      unless rule.is_a?(Rule)
        raise TypeError, "the rule of minute must be a class or subclass of Rule"
      end

      if rule.is_a?(ScopeRule)
        raise TypeError, "the rule of minute cannot be a class or subclass of ScopeRule"
      end
      @minute = rule
      @minute.unit = :minute
    end

    def minute
      @minute ||= DefaultRule.new(:minute)
    end

    # loop syntax
    #   - loop
    #     - example: loop 5.times
    def loop=(rule)
      unless rule.is_a?(Rule)
        raise TypeError, "the rule of loop must be a class or subclass of Rule"
      end

      @loop = rule
      @loop.unit = :loop
    end
    def loop
      @loop ||= DefaultRule.new(":loop")
    end

    # time list syntax
    #   - time
    #     - example: time "10:10:30", "9:10:20", "20:10:20"
    def time=(time)
      unless rule.is_a?(TimeListRule)
        raise TypeError, "the rule of time must be a TimeList Rule"
      end

      @time = rule
      @time.unit = :time
    end
    def time
      @time ||= DefaultRule.new(":time")
    end

    # date list syntax
    #   - date
    #     - example: date "2023-10-10", "2013-10-11", "2023-11-10"
    def date=(date)
      unless rule.is_a?(DateListRule)
        raise TypeError, "the rule of time must be a DateList Rule"
      end

      @date = rule
      @date.unit = :date
    end
    def date
      @date ||= DefaultRule.new(":date")
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
      if has_loop_rule?
        puts "#{desc} has loop rule.".ansi.blue
        conform = check_for_loop_rule?(last_exec_time)
      else
        puts "#{desc} no loop rule."
        conform &&= year.is_conform_rule?(last_exec_time)
        conform &&= month.is_conform_rule?(last_exec_time)
        conform &&= day.is_conform_rule?(last_exec_time)
        conform &&= hour.is_conform_rule?(last_exec_time)
        conform &&= minute.is_conform_rule?(last_exec_time)
      end
      puts "#{desc} check all rule: #{conform}".ansi.blue
      return conform
    end

    private def has_loop_rule?
      rules = [year, month, day, hour, minute]
      return rules.any?{ |rule| rule.is_a?(IntervalRule) }
    end

    private def check_for_loop_rule?(last_exec_time)
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
    # Filenames
    #################################

    # ~/.taskloop/cache/<project-sha>.
    attr_accessor :data_proj_dir
    # # <project-path>/Taskfile
    # attr_accessor :taskfile_path
    # attr_accessor :taskfile_lock_path

    def logfile_path
      return File.join(@data_proj_dir, logfile_name)
    end

    def timefile_path
      return File.join(@data_proj_dir, timefile_name)
    end

    def logfile_name
      return sha1 + "_log"
    end
    def timefile_name
      return sha1 + "_time"
    end
    def loopfile_name
      return sha1 + "_loop"
    end

    def write_to_logfile(content)
      file = File.open(logfile_path, "w")
      file.puts content
      file.close
    end

    def write_to_timefile(content)
      file = File.open(timefile_path, "w")
      file.puts content
      file.close
    end

    def write_to_loopfile(content)
      file = File.open(loopfile_name, "w")
      file.puts content
      file.close
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
