module Taskloop

  class ScopeRule < Rule

    SCOPES = [
      :before    => 0,
      :between   => 1,
      :after     => 2,
    ]

    attr_accessor :scope

    def initialize(unit, scope)
      super unit
      @scope = scope
    end
  end



  class BeforeScopeRule < ScopeRule
    attr_accessor :right

    def initialize(unit, scope, right)
      super unit, scope
      @right = right
    end
  end



  class BetweenScopeRule < ScopeRule
    attr_accessor :left

    attr_accessor :right

    def initialize(unit, scope, left, right)
      super unit, scope
      @left = left
      @right = right
    end
  end



  class AfterScopeRule < ScopeRule
    attr_accessor :left

    def initialize(unit, scope, left)
      super unit, scope
      @left = left
    end
  end

end