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

      unless @value != nil && @value.is_a?(Integer)
        return -1
      end

      return @value
    end

    def is_week_value?
      if @unit == :day && Task::WEEK.has_key?(@value)
        return true
      end
      return false
    end

    def is_conform_rule?(last_exec_time)
      current = Time.now
      value = value_value
      result = false
      case @unit
      when :year then
        result = current.year == value
      when :month then
        result = current.month == value
      when :day then
        if is_week_value?
          result = current.wday == (value % TaskLoop::WEEK_BASE)
        else
          result = current.day == value
        end
      when :hour then
        result = current.hour == value
      when :minute then
        result = current.min == value
      end
      return result
    end
  end

end