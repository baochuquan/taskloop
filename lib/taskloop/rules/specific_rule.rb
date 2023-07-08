module Taskloop

  class SpecificRule < Rule

    attr_accessor :value

    def initialize(unit, value)
      super unit
      @value = value
    end
  end

end