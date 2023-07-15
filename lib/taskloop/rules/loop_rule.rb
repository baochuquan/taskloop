module TaskLoop
  class LoopRule < Rule

    attr_accessor :interval

    def initialize(unit, interval)
      super unit
      @interval = interval
    end

    def is_week_value?
      return false
    end

    def is_conform_rule?(last_exec_time)
      # loop rule is different for other rules. It should be calculated by combining the interval times of all units.
      # So here returns false
      return false
    end

    def description
      super + '_loop_' + interval.to_s
    end
  end

end