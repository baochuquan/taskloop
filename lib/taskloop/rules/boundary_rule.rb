module TaskLoop

  class BoundaryRule < Rule

    BOUNDARY = {
      :start    => 0,
      :end      => 1,
    }

    attr_accessor :boundary

    def initialize(unit, boundary)
      super unit
      @boundary = boundary
    end

    def desc
      super + "; boundary: #{boundary.to_s}"
    end
  end
end