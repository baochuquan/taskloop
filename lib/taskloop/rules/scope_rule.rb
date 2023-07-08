module Taskloop

  class ScopeRule < Rule

    SCOPE = {
      :before    => 0,
      :between   => 1,
      :after     => 2,
    }

    attr_accessor :scope

    def initialize(unit, scope)
      super unit
      @scope = scope
    end
  end

  class BeforeScopeRule < ScopeRule

    attr_accessor :right

    def initialize(unit, scope, right)
      super unit, scope
      @right = right
    end

    def invalidate!
      super
      if Task::WEEK.has_key?(right)
        return
      end
      if Task::DAY.has_key?(right)
        return
      end
      if Task::MONTH.has_key?(right)
        return
      end

      unless right.is_a?(Integer)
        raise TypeError, "'right' need to be Symbol or Integer"
      end

      unless right > 0
        raise ArgumentError, "'right' must greater than 0."
      end
    end
  end



  class BetweenScopeRule < ScopeRule

    attr_accessor :left

    attr_accessor :right

    def initialize(unit, scope, left, right)
      super unit, scope
      @left = left
      @right = right
    end

    def invalidate!
      super
      if Task::WEEK.has_key?(left) and Task::WEEK.has_key?(right)
        unless left < right
          raise ArgumentError, "'left' must less than 'right'"
        end
        return
      end
      if Task::DAY.has_key?(left) and Task::DAY.has_key?(right)
        unless left < right
          raise ArgumentError, "'left' must less than 'right'"
        end
        return
      end
      if Task::MONTH.has_key?(left) and Task::MONTH.has_key?(right)
        unless left < right
          raise ArgumentError, "'left' must less than 'right'"
        end
        return
      end

      unless left.is_a?(Integer) and right.is_a?(Integer)
        raise TypeError, "both 'left' and 'right' need to be Symbol or Integer"
      end

      unless left < right
        raise ArgumentError, "'left' must less than 'right'"
      end
    end
  end
  


  class AfterScopeRule < ScopeRule

    attr_accessor :left

    def initialize(unit, scope, left)
      super unit, scope
      @left = left
    end

    def invalidate!
      super
      if Task::WEEK.has_key?(left)
        return
      end
      if Task::DAY.has_key?(left)
        return
      end
      if Task::MONTH.has_key?(left)
        return
      end

      unless left.is_a?(Integer)
        raise TypeError, "'left' need to be Symbol or Integer"
      end

      unless left > 0
        raise ArgumentError, "'left' must greater than 0."
      end
    end

  end

end