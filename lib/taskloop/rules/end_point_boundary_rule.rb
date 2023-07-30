module TaskLoop
  class EndPointBoundaryRule < BoundaryRule
    attr_accessor :value
    def initialize(unit, value)
      super unit, :end
      @value = value
    end

    def is_conform_rule?(last_exec_time)
      current = Time.now.to_i
      date_format = "%Y-%m-%d %H:%M:%S"
      date_object = Time.strptime(value, date_format)
      end_time = date_object.to_i
      return current <= end_time
    end

    def desc
      super + " to #{value}"
    end
  end
end