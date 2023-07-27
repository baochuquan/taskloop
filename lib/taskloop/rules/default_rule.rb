module TaskLoop
  class DefaultRule < Rule
    def initialize(unit)
      super unit
    end

    def is_conform_rule?(last_exec_time)
      return true
    end

    def desc
      super + "; default rule"
    end
  end
end