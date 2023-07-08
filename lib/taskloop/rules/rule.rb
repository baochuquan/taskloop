module Taskloop


  class Rule

    UNITS = [
      :unknown     => 0,
      :minute      => 1,
      :hour        => 2,
      :day         => 3,
      :month       => 4,
      :year        => 5,
    ]

    attr_accessor :unit

    def initialize(unit = :unknown)
      @unit = unit
    end
    def next_execute_time(last_execute_time)
      raise NotImplementedError, 'subclass need implement this method!'
    end
  end
end