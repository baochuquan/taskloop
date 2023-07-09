module TaskLoop

  class SpecificRule < Rule

    attr_accessor :value

    def initialize(unit, value)
      super unit
      @value = value
    end

    def value_value
      if (Task::DAY.has_key?(@value))
        return Task::DAY[@value]
      end
      if (Task::WEEK.has_key?(@value))
        return Task::WEEK[@value]
      end
      if (Task::MONTH.has_key?(@value))
        return Task::MONTH[@value]
      end

      unless @value != nil and @value.is_a?(Integer)
        return -1
      end

      return @value
    end

    def hash
      super + '_specific_' + value_value.to_s
    end
  end

end