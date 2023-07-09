module TaskLoop
  class BeforeScopeRule < ScopeRule

    attr_accessor :right

    def initialize(unit, scope, right)
      super unit, scope
      @right = right
    end

    def invalidate!
      super
      if @unit == :day
        unless Task::WEEK.has_key?(@right) or Task::DAY.has_key?(@right)
          raise ArgumentError, "#{@right} must be a Symbol defined in Task::WEEK or Task::DAY"
        end
        return
      end

      if @unit == :month
        unless Task::MONTH.has_key?(@right)
          raise ArgumentError, "#{@right} must be a Symbol defined in Task::MONTH"
        end
        return
      end

      unless @right.is_a?(Integer)
        raise TypeError, "'right' need to be Symbol or Integer"
      end

      if @unit == :minute and (@right < 0 or @right > 59)
        raise ArgumentError, "'right' for 'minute' must >= 0 and <= 59"
      end

      if @unit == :hour and (@right < 0 or @right > 23)
        raise ArgumentError, "'right' for 'hour' must >= 0 and <= 23"
      end
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

      unless @right != nil and @right.is_a?(Integer)
        return -1
      end

      return @right
    end

    def is_week_value?
      if @unit == :day and Task::WEEK.has_key?(@right)
        return true
      end
      return false
    end

    def is_conform_rule?(last_exec_time)
      current = Time.now
      value = right_value
      result = false
      case @unit
      when :year then
        result = current.year < value
      when :month then
        result = current.month < value
      when :day then
        if is_week_value?
          result = current.wday < (value % TaskLoop::WEEK_BASE)
        else
          result = current.day < value
        end
      when :hour then
        result = current.hour < value
      end
      puts "check rule #{self} => #{@unit}, #{result}"
      return result
    end

    def description
      super + '_' + right_value.to_s
    end
  end
end