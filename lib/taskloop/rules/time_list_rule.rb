module TaskLoop
  class TimeListRule < Rule

    require 'time'

    attr_writer :times

    def times
      @times ||= []
    end

    def times_values
      values = []
      times.each do |time|
        time_format = "%H:%M:%S"
        time_object = Time.strptime(time, time_format)
        values.push(time_object)
      end
      return values
    end

    def initialize(unit, times)
      super unit
      unless times != nil && times.length > 0
        raise ArgumentError, "times arguments need at least one value."
      end

      @times = times
    end

    def is_week_value?
      return false
    end

    def is_conform_rule?(last_exec_time)
      current = Time.now
      result = false

      times_values.each do |time|
        result = result || (time.hour == current.hour && time.min == current.min)
      end
      return result
    end

    def desc
      super + "; time_list: #{times.join(', ')}"
    end
  end
end