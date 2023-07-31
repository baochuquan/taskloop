module TaskLoop
  class BetweenScopeRule < ScopeRule

    attr_accessor :left

    attr_accessor :right

    def initialize(unit, left, right)
      super unit, :between
      @left = left
      @right = right
    end

    # def invalidate!
    #   super
    #   if @unit == :day
    #     if Task::WEEK.has_key?(@left) && Task::WEEK.has_key?(@right)
    #       unless Task::WEEK[@left] < Task::WEEK[@right]
    #         raise ArgumentError, "'left' must less than 'right'"
    #       end
    #       return
    #     end
    #     if Task::DAY.has_key?(@left) && Task::DAY.has_key?(@right)
    #       unless Task::WEEK[@left] < Task::WEEK[@right]
    #         raise ArgumentError, "'left' must less than 'right'"
    #       end
    #       return
    #     end
    #
    #     raise ArgumentError, "'left' and 'right' must be the same type."
    #   end
    #
    #   if @unit == :month
    #     unless Task::MONTH.has_key?(@left)
    #       raise ArgumentError, "#{left} must be a Symbol defined in Task::MONTH"
    #     end
    #     return
    #   end
    #
    #   unless @left.is_a?(Integer) && @right.is_a?(Integer)
    #     raise TypeError, "both 'left' and 'right' need to be Symbol or Integer"
    #   end
    #
    #   unless @left < @right
    #     raise ArgumentError, "'left' must less than 'right'"
    #   end
    #
    #   if @unit == :minute && (@left < 0 || @right > 59)
    #     raise ArgumentError, "'left' and 'right' for 'minute' must >= 0 and <= 59"
    #   end
    #
    #   if @unit == :hour && (@left < 0 || @right > 23)
    #     raise ArgumentError, "'left', 'right' for 'hour' must >= 0 and <= 23"
    #   end
    #
    #   if @unit == :year && @left < 0
    #     raise ArgumentError, "'left' must greater than 0"
    #   end
    # end

    def left_value
      if (Task::DAY.has_key?(@left))
        return Task::DAY[@left]
      end
      if (Task::WEEK.has_key?(@left))
        return Task::WEEK[@left]
      end
      if (Task::MONTH.has_key?(@left))
        return Task::MONTH[@left]
      end

      unless @left != nil && @left.is_a?(Integer)
        return -1
      end

      return @left
    end

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
      left = left_value
      right = right_value
      result = false
      case @unit
      when :year then
        result = left <= current.year >= left && current.year <= right
      when :month then
        result = left <= current.month && current.month <= right
      when :week then
        result = (left % TaskLoop::WEEK_BASE) <= current.wday && current.wday <= (right % TaskLoop::WEEK_BASE)
      when :day then
        result = left <= current.day && current.day <= right
      when :hour then
        result = left <= current.hour && current.hour <= right
      end
      return result
    end

    def desc
      super + " #{left}, #{right}"
    end
  end
end