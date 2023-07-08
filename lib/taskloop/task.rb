module Taskloop
  class Task

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
      :month1    => 1,
      :month2    => 2,
      :month3    => 3,
      :month4    => 4,
      :month5    => 5,
      :month6    => 6,
      :month7    => 7,
      :month8    => 8,
      :month9    => 9,
      :month10   => 10,
      :month11   => 11,
      :month12   => 12,
    }

    WEEK = {
      :Mon       => 1,
      :Tue       => 2,
      :Wed       => 3,
      :Thu       => 4,
      :Fri       => 5,
      :Sat       => 6,
      :Sun       => 7,
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

    # the path of a task
    attr_accessor :path

    def initialize()
      yield self
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
    #     - example: in January, February, March, April, June, July, August, September, October, November, December;
    #     - example: in month1, month2, month3, ....
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
    #     - example: on Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday;
    #     - example: on day1, day2, day3;
    # loop syntax
    #   - every
    #     - example: every 10
    # scope syntax
    #   - before
    #     - example: before day10
    #   - between
    #     - example: between day10, day19
    #     - example: between Monday, Friday
    #   - after
    #     - example: after day10
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

    def test
      Task.new do |t|
        t.path = "xxx"
        t.minute = every 1.minute
        t.hour = at 10.hour
        t.day = on :Sun
        t.month = of :Feb
        t.year = of 2023
      end
    end

  end
end

class Integer
  def minute
    self
  end

  def hour
    self
  end

  def day
    self
  end

  def month
    self
  end

  def year
    self
  end
end