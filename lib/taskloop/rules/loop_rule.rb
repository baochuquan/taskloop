module TaskLoop
  class LoopRule < Rule

    attr_accessor :interval

    def initialize(unit, interval)
      super unit
      @interval = interval
    end

    def hash
      super + '_loop_' + interval.to_s
    end

    def next_execute_time(last_execute_time)

    end
  end

end