module TaskLoop
  class StartPointBoundaryRule < BoundaryRule
    attr_accessor :value
    def initialize(unit, value)
      super unit, :start
      @value = value
    end

    def is_conform_rule?(last_exec_time)
      current = Time.now.to_i
      date_format = "%Y-%m-%d %H:%M:%S"
      date_object = Time.strptime(value, date_format)
      start_time = date_object.to_i
      return current >= start_time
    end

    def desc
      super + " from #{value}"
    end
  end
end