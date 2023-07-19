module TaskLoop
  class DateListRule < Rule

    attr_accessor :dates

    def initialize(unit, dates)
      super unit
      @dates = dates
    end

    def is_week_value?
      return false
    end

    def is_conform_rule?(last_exec_time)
      return false
    end
  end

end