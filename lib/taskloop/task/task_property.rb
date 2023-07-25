module TaskLoop
  module TaskProperty

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

    # the name of task
    attr_accessor :name
    # the path of task
    attr_accessor :path

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
      @loop ||= DefaultRule.new(:loop)
    end

    # time list syntax
    #   - time
    #     - example: time "10:10:30", "9:10:20", "20:10:20"
    def time=(rule)
      unless rule.is_a?(TimeListRule)
        raise TypeError, "the rule of time must be a TimeList Rule"
      end

      @time = rule
      @time.unit = :time
    end
    def time
      @time ||= DefaultRule.new(:time)
    end

    # date list syntax
    #   - date
    #     - example: date "2023-10-10", "2013-10-11", "2023-11-10"
    def date=(rule)
      unless rule.is_a?(DateListRule)
        raise TypeError, "the rule of time must be a DateList Rule"
      end

      @date = rule
      @date.unit = :date
    end
    def date
      @date ||= DefaultRule.new(:date)
    end

    #################################
    # Help Methods
    #################################
    def hasDate?
      !date.is_a?(DefaultRule)
    end

    def hasTime?
      !time.is_a?(DefaultRule)
    end

    def hasYMD?
      [year, month, day].any? { |rule| !rule.is_a?(DefaultRule) }
    end

    def hasHM?
      [hour, minute].any? { |rule| !rule.is_a?(DefaultRule) }
    end

    def has_interval_rule?
      rules = [year, month, day, hour, minute]
      return rules.any?{ |rule| rule.is_a?(IntervalRule) }
    end

    def loop_count
      count = 0
      File.open(loopfile_path, 'r') do |file|
        count = file.gets.to_i
      end
      return count
    end

    def last_time
      timestamp = 0
      File.open(timefile_path, 'r') do |file|
        timestamp = file.gets.to_i
      end
      return Time.at(timestamp)
    end
  end
end