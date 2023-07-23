module TaskLoop
  class TimeListRule < Rule

    attr_accessor :times

    def initialize(unit, times)
      super unit
      @times = times
    end

    def is_week_value?
      return false
    end

    def is_conform_rule?(last_exec_time)
      return false
    end

    def desc
      super + "; TODO: @baocq"
    end
  end
end