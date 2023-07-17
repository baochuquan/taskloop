module TaskLoop
  module DSL

    #################################
    # Loop Syntax
    #################################
    def interval(interval)
      IntervalRule.new(:unknown, interval)
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
      SpecificRule.new(:unknown, value)
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

    #################################
    # Loop Syntax
    #################################
    def loop(count)
      LoopRule.new(:unknown, count)
    end

    #################################
    # Env
    #################################
    def env(name, value)
      ENV[name] = value
    end
  end
end
