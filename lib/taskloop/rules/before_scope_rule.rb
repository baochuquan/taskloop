module TaskLoop
  class BeforeScopeRule < ScopeRule

    attr_accessor :right

    def initialize(unit, right)
      super unit, :before
      @right = right
    end

    # def invalidate!
    #   super
    #   if @unit == :day
    #     unless Task::WEEK.has_key?(@right) || Task::DAY.has_key?(@right)
    #       raise ArgumentError, "#{@right} must be a Symbol defined in Task::WEEK or Task::DAY"
    #     end
    #     return
    #   end
    #
    #   if @unit == :month
    #     unless Task::MONTH.has_key?(@right)
    #       raise ArgumentError, "#{@right} must be a Symbol defined in Task::MONTH"
    #     end
    #     return
    #   end
    #
    #   unless @right.is_a?(Integer)
    #     raise TypeError, "'right' need to be Symbol or Integer"
    #   end
    #
    #   if @unit == :minute && (@right < 0 || @right > 59)
    #     raise ArgumentError, "'right' for 'minute' must >= 0 and <= 59"
    #   end
    #
    #   if @unit == :hour && (@right < 0 || @right > 23)
    #     raise ArgumentError, "'right' for 'hour' must >= 0 and <= 23"
    #   end
    # end

    def right_value
      if (Task::DAY.has_key?(@right))
        return Task::DAY[@right]
      end
      if (Task::WEEK.has_key?(@right))
        return Task::WEEK[@right]
      end
      if (Task::MONTH.has_key?(@right))
        return Task::MONTH[@right]
      end

      unless @right != nil && @right.is_a?(Integer)
        return -1
      end

      return @right
    end

    def is_conform_rule?(last_exec_time)
      current = Time.now
      value = right_value
      result = false
      case @unit
      when :year then
        result = current.year <= value
      when :month then
        result = current.month <= value
      when :week then
        result = current.wday <= value
      when :day then
        result = current.day <= value
      when :hour then
        result = current.hour <= value
      when :minute then
        result = current.min <= value
      end
      return result
    end

    def desc
      super + " #{right}"
    end
  end
end