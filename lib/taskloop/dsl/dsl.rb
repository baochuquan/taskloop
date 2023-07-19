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
    # Time List Syntax
    #################################
    def time(*args)
      TimeListRule.new(:unknown, args)
    end

    #################################
    # Date List Syntax
    #################################
    def date(*args)
      DateListRule.new(:unknown, args)
    end

    #################################
    # Env
    #################################
    def env(name, value)
      ENV[name] = value
    end


  end
end
