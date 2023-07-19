module TaskLoop
  class Rule

    UNIT = {
      :unknown     => 0,
      :minute      => 1,
      :hour        => 2,
      :day         => 3,
      :month       => 4,
      :year        => 5,
      :loop        => 7,
    }

    attr_accessor :unit

    def initialize(unit = :unknown)
      @unit = unit
    end

    def is_week_value?
      raise NotImplementedError, 'subclass need implement this method!'
    end

    def is_conform_rule?(last_exec_time)
      raise NotImplementedError, 'subclass need implement this method!'
    end
  end
end