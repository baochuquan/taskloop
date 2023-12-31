module TaskLoop

  class ScopeRule < Rule

    SCOPE = {
      :before    => 0,
      :between   => 1,
      :after     => 2,
    }

    attr_accessor :scope

    def initialize(unit, scope)
      super unit
      @scope = scope
    end

    def desc
      super + "; scope: #{scope.to_s}"
    end
  end
end