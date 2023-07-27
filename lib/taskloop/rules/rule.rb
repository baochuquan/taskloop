module TaskLoop
  class Rule

    UNIT = {
      :unknown     => 0,
      :minute      => 1,      # support interval/specific syntax
      :hour        => 2,      # support interval/scope/specific syntax
      :day         => 3,      # support interval/scope/specific syntax
      :month       => 4,      # support interval/scope/specific syntax
      :year        => 5,      # support interval/scope/specific syntax
      :week        => 6,      # support scope/specific syntax
      :loop        => 7,      # only support loop syntax
      :date        => 8,      # only support date list syntax
      :time        => 9,      # only support time list syntax
    }

    attr_accessor :unit

    def initialize(unit = :unknown)
      @unit = unit
    end

    def is_conform_rule?(last_exec_time)
      raise NotImplementedError, 'subclass need implement this method!'
    end

    def desc
      "unit: #{unit.to_s}"
    end
  end
end