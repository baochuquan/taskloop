module TaskLoop
  class LoopRule < Rule

    attr_accessor :count

    def initialize(unit, count)
      super unit
      @count = count
    end

    def is_week_value?
      return false
    end

    def is_conform_rule?(last_exec_time)
      # loop rule is different for other rules. It should based on task loop file.
      # So here returns false
      return false
    end

    def desc
      super + "; loop: #{count}"
    end
  end
end