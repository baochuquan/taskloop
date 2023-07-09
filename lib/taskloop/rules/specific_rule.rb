module TaskLoop

  class SpecificRule < Rule

    attr_accessor :value

    def initialize(unit, value)
      super unit
      @value = value
    end

    def hash
      super + '_specific_' + value.to_s
    end
  end

end