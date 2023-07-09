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

    attr_accessor :tag
    # the path of a task
    attr_accessor :path

    def initialize()
      yield self
      puts "task.sha1 => #{sha1}"
      @@tasklist.push(self)
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
      @year ||= LoopRule.new(:year, 1)
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
      @month||= LoopRule.new(:month, 1)
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
      @day ||= LoopRule.new(:day, 1)
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
      @hour ||= LoopRule.new(:hour, 1)
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
      @minute ||= LoopRule.new(:minute, 1)
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

    def is_conform_rule?
      timestamp = 0
      File.open(timefile_path, 'r') do |file|
        timestamp = file.gets.to_i
      end
      current =Time.at(timestamp)
      conform = year.is_conform_rule?(current) and month.is_conform_rule?(current) and day.is_conform_rule?(current) and hour.is_conform_rule?(current) and minute.is_conform_rule?(current)
      return conform
    end

    #################################
    # Filenames
    #################################

    attr_accessor :proj_cache_dir

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
      sha1_digest.update(description)
      return sha1_digest.hexdigest
    end

    def description
      [year.description, month.description, day.description, hour.description, minute.description, tag.to_s].join('_')
    end
  end
end
