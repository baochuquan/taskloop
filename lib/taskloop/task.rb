module TaskLoop
  class Task
    require 'digest'
    require 'taskloop/extension/string_extension'
    require 'taskloop/extension/integer_extension'

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

    attr_writer :tag
    # the path of a task
    attr_accessor :path

    def initialize()
      yield self
      puts "task.sha1 => #{sha1}"
      @@tasklist.push(self)
    end

    def tag
      @tag ||= 0
    end

    #################################
    # Setters & Getters
    #################################
    # specific syntax
    #   - of
    #     - example: in 2024
    # loop syntax
    #   - every
    #     - example: every 1
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
    # loop syntax
    #   - every
    #     - example: every 1
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
    # loop syntax
    #   - every
    #     - example: every 10
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
    # loop syntax
    #   - every
    #     - example: every 10
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

    # # specific syntax
    #     #   - at
    #     #     - example: at 59; at 45
    #     # loop syntax
    #     #   - every
    #     #     - example: every 5
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


    #################################
    # Utils
    #################################
    def invalidate!

    end

    def self.tasklist
      @@tasklist
    end

    def self.tasklist=(value)
      @@tasklist = value
    end

    #################################
    # Check Methods
    #################################

    def is_rules_mutual_relationship_ok?
      result = true
      rules = [minute, hour, day, month, year]
      rIdx = rules.rindex { |rule| rule.is_a?(LoopRule) }
      unless rIdx != nil
        return result
      end

      rules.each_with_index do |rule, index|
        if index < rIdx and (rule.is_a?(ScopeRule) or rule.is_a?(SpecificRule))
          result = false
        end
      end
      unless result
        puts "Error: the rules of the task may conflict, please check them again.".ansi.red
        puts "    Task description: #{rule_description}".ansi.red
        puts "    Task path: #{path}".ansi.red
        puts "    Task defined in #{taskfile_path}".ansi.red
        puts "    Suggestion: SpecificRule and ScopeRule cannot execute during LoopRules".ansi.red
      end
      return result
    end

    def is_conform_rule?
      timestamp = 0
      File.open(timefile_path, 'r') do |file|
        timestamp = file.gets.to_i
      end
      last_exec_time = Time.at(timestamp)
      conform = true
      if has_loop_rule?
        conform = check_for_loop_rule?(last_exec_time)
      else
        conform &&= year.is_conform_rule?(last_exec_time)
        conform &&= month.is_conform_rule?(last_exec_time)
        conform &&= day.is_conform_rule?(last_exec_time)
        conform &&= hour.is_conform_rule?(last_exec_time)
        conform &&= minute.is_conform_rule?(last_exec_time)
      end
      puts "conform => #{conform}"
      return conform
    end

    def has_loop_rule?
      rules = [year, month, day, hour, minute]
      return rules.any?{ |rule| rule.is_a?(LoopRule) }
    end

    def check_for_loop_rule?(last_exec_time)
      result = true
      min = 0
      if year.is_a?(LoopRule)
        min += year.interval * YEAR_MIN
      else
        result &&= year.is_conform_rule?(last_exec_time)
      end
      if month.is_a?(LoopRule)
        min += month.interval * MONTH_MIN
      else
        result &&= year.is_conform_rule?(last_exec_time)
      end
      if day.is_a?(LoopRule)
        min += day.interval * DAY_MIN
      else
        result &&= year.is_conform_rule?(last_exec_time)
      end
      if hour.is_a?(LoopRule)
        min += day.interval * HOUR_MIN
      else
        result &&= year.is_conform_rule?(last_exec_time)
      end
      if minute.is_a?(LoopRule)
        min += minute.interval * MINUTE_MIN
      else
        result &&= year.is_conform_rule?(last_exec_time)
      end
      correction = 20
      result &&= (Time.now.to_i - last_exec_time.to_i + correction) / 60.0 >= min
      return result
    end

    #################################
    # Filenames
    #################################

    attr_accessor :proj_cache_dir
    attr_accessor :taskfile_path

    def logfile_path
      return File.join(@proj_cache_dir, logfile_name)
    end

    def timefile_path
      return File.join(@proj_cache_dir, timefile_name)
    end

    def logfile_name
      return sha1 + "_log"
    end
    def timefile_name
      return sha1 + "_time"
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

    #################################
    # Sha1 and description
    #################################
    def sha1
      return rule_sha1 + '_' + path_sha1
    end

    def path_sha1
      sha1_digest = Digest::SHA1.new
      sha1_digest.update(@path)
      return sha1_digest.hexdigest[0..7]
    end

    def rule_sha1
      sha1_digest = Digest::SHA1.new
      sha1_digest.update(rule_description)
      return sha1_digest.hexdigest
    end

    def rule_description
      [year.description, month.description, day.description, hour.description, minute.description, tag.to_s].join('_')
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
