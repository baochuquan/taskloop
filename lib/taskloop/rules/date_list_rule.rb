module TaskLoop
  class DateListRule < Rule
    require 'time'

    attr_writer :dates

    def dates
      @dates ||= []
    end

    def dates_values
      values = []
      dates.each do |date|
        date_format = "%Y-%m-%d"
        date_object = Time.strptime(date, date_format)
        values.push(date_object)
      end
      return values
    end

    def initialize(unit, dates)
      super unit
      unless dates != nil && dates.length > 0
        raise ArgumentError, "dates arguments need at least one value."
      end
      @dates = dates
    end

    def is_conform_rule?(last_exec_time)
      current = Time.now
      result = false

      dates_values.each do |date|
        result = result || (date.year == current.year && date.month == current.month && date.day == current.day)
      end
      return result
    end

    def desc
      super + "; date_list: #{dates.join(', ')}"
    end
  end
end