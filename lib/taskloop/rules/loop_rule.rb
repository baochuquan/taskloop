module Taskloop
  class LoopRule < Rule

    attr_accessor :interval

    def initialize(unit, interval)
      super unit
      @interval = interval
    end

    def hash
      super + '_' + "loop" + '_' + interval
    end

    def next_execute_time(last_execute_time)

    end
  end

end