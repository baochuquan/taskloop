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
    def at(*values)
      SpecificRule.new(:unknown, values)
    end

    #################################
    # Scope Syntax
    #################################
    def before(right)
      BeforeScopeRule.new(:unknown, right)
    end

    def between(left, right)
      BetweenScopeRule.new(:unknown, left, right)
    end

    def after(left)
      AfterScopeRule.new(:unknown, left)
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
    # Boundary Syntax
    #################################
    def from(value)
      StartPointBoundaryRule.new(:unknown, value)
    end

    def to(value)
      EndPointBoundaryRule.new(:unknown, value)
    end

    #################################
    # Env
    #################################
    def env(name, value)
      ENV[name] = value
    end


  end
end
