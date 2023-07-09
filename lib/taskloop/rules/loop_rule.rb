module TaskLoop
  class LoopRule < Rule

    attr_accessor :interval

    def initialize(unit, interval)
      super unit
      @interval = interval
    end

    def is_week_value?
      return false
    end

    def is_conform_rule?(last_exec_time)
      current = Time.now
      interval = @interval
      result = false
      case @unit
      when :year then
        result = current.year - last_exec_time.year >= interval
      when :month then
        result = current.month - last_exec_time.month >= interval
      when :day then
        result = current.day - last_exec_time.day >= interval
      when :hour then
        result = current.hour - last_exec_time.hour >= interval
      when :minute then
        result = current.min - last_exec_time.min >= interval
      end
      puts "check rule #{self} => #{@unit}, #{result}"
      return result
    end

    def description
      super + '_loop_' + interval.to_s
    end
  end

end