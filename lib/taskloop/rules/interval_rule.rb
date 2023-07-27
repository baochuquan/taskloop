module TaskLoop
  class IntervalRule < Rule

    attr_accessor :interval

    def initialize(unit, interval)
      super unit
      @interval = interval
    end

    def is_conform_rule?(last_exec_time)
      # interval rule is different for other rules. It should be calculated by combining the interval times of all units.
      # So here returns false
      return false
    end

    def desc
      super + "; interval: #{interval}"
    end
  end

end