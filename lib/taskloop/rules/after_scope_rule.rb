module TaskLoop
  class AfterScopeRule < ScopeRule

    attr_accessor :left

    def initialize(unit, scope, left)
      super unit, scope
      @left = left
    end

    def invalidate!
      super
      if @unit == :day
        unless Task::WEEK.has_key?(@left) or Task::DAY.has_key?(@left)
          raise ArgumentError, "#{left} must be a Symbol defined in Task::WEEK or Task::DAY"
        end
        return
      end

      if @unit == :month
        unless Task::MONTH.has_key?(@left)
          raise ArgumentError, "#{left} must be a Symbol defined in Task::MONTH"
        end
        return
      end

      unless @left.is_a?(Integer)
        raise TypeError, "'left' need to be Symbol or Integer"
      end

      if @unit == :minute and (@left < 0 or @left > 59)
        raise ArgumentError, "'right' for 'minute' must >= 0 and <= 59"
      end

      if @unit == :hour and (@left < 0 or @left > 23)
        raise ArgumentError, "'right' for 'hour' must >= 0 and <= 23"
      end
    end


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

      unless @left != nil and @left.is_a?(Integer)
        return -1
      end

      return @left
    end

    def is_week_value?
      if @unit == :day and Task::WEEK.has_key?(@left)
        return true
      end
      return false
    end

    def is_conform_rule?(last_exec_time)
      current = Time.now
      value = left_value
      result = false
      case @unit
      when :year then
        result = current.year > value
      when :month then
        result = current.month > value
      when :day then
        if is_week_value?
          result = current.wday > (value % TaskLoop::WEEK_BASE)
        else
          result = current.day > value
        end
      when :hour then
        result = current.hour > value
      end
      return result
    end

    # def description
    #   super + '_' + left_value.to_s
    # end
  end
end