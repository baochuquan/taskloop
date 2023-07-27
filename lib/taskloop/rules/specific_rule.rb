module TaskLoop

  class SpecificRule < Rule

    attr_accessor :values

    def initialize(unit, values)
      super unit
      unless values != nil && values.length > 0
        raise ArgumentError, "values arguments need at least one value."
      end

      @values = values
    end

    def values_values
      if @unit == :week
        return @values.map { |key| Task::WEEK[key] }
      end

      if @unit == :day
        return @values.map { |key| Task::DAY[key] }
      end

      if @unit == :month
        return @values.map { |key| Task::MONTH[key] }
      end

      return @values
    end

    def is_conform_rule?(last_exec_time)
      current = Time.now
      valuess = values_values
      result = false
      case @unit
      when :year then
        result = valuess.include?(current.year)
      when :month then
        result = valuess.include?(current.month)
      when :week then
        result = valuess.include?(TaskLoop::WEEK_BASE + current.wday)
      when :day then
        result = valuess.include?(current.day)
      when :hour then
        result = valuess.include?(current.hour)
      when :minute then
        result = valuess.include?(current.min)
      end
      return result
    end

    def desc
      super + "; specific: #{values.join(', ')}"
    end
  end
end