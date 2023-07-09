module TaskLoop

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

    def hash
      super + '_' + @scope.to_s
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
      if @unit == :day
        unless Task::WEEK.has_key?(right) or Task::DAY.has_key?(right)
          raise ArgumentError, "#{right} must be a Symbol defined in Task::WEEK or Task::DAY"
        end
        return
      end

      if @unit == :month
        unless Task::MONTH.has_key?(right)
          raise ArgumentError, "#{right} must be a Symbol defined in Task::MONTH"
        end
        return
      end

      unless right.is_a?(Integer)
        raise TypeError, "'right' need to be Symbol or Integer"
      end

      if @unit == :minute and (right < 0 or right > 59)
        raise ArgumentError, "'right' for 'minute' must >= 0 and <= 59"
      end

      if @unit == :hour and (right < 0 or right > 23)
        raise ArgumentError, "'right' for 'hour' must >= 0 and <= 23"
      end
    end

    def hash
      super + '_' + right.to_s
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
      if @unit == :day
        if Task::WEEK.has_key?(left) and Task::WEEK.has_key?(right)
          unless Task::WEEK[left] < Task::WEEK[right]
            raise ArgumentError, "'left' must less than 'right'"
          end
          return
        end
        if Task::DAY.has_key?(left) and Task::DAY.has_key?(right)
          unless Task::WEEK[left] < Task::WEEK[right]
            raise ArgumentError, "'left' must less than 'right'"
          end
          return
        end

        raise ArgumentError, "'left' and 'right' must be the same type."
      end

      if @unit == :month
        unless Task::MONTH.has_key?(left)
          raise ArgumentError, "#{left} must be a Symbol defined in Task::MONTH"
        end
        return
      end

      unless left.is_a?(Integer) and right.is_a?(Integer)
        raise TypeError, "both 'left' and 'right' need to be Symbol or Integer"
      end

      unless left < right
        raise ArgumentError, "'left' must less than 'right'"
      end

      if @unit == :minute and (left < 0 or right > 59)
        raise ArgumentError, "'left' and 'right' for 'minute' must >= 0 and <= 59"
      end

      if @unit == :hour and (left < 0 or right > 23)
        raise ArgumentError, "'left', 'right' for 'hour' must >= 0 and <= 23"
      end

      if @unit == :year and left < 0
        raise ArgumentError, "'left' must greater than 0"
      end
    end

    def hash
      super + '_' + left.to_s + '_' + right.to_s
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
      if @unit == :day
        unless Task::WEEK.has_key?(left) or Task::DAY.has_key?(left)
          raise ArgumentError, "#{left} must be a Symbol defined in Task::WEEK or Task::DAY"
        end
        return
      end

      if @unit == :month
        unless Task::MONTH.has_key?(left)
          raise ArgumentError, "#{left} must be a Symbol defined in Task::MONTH"
        end
        return
      end

      unless left.is_a?(Integer)
        raise TypeError, "'left' need to be Symbol or Integer"
      end

      if @unit == :minute and (left < 0 or left > 59)
        raise ArgumentError, "'right' for 'minute' must >= 0 and <= 59"
      end

      if @unit == :hour and (left < 0 or left > 23)
        raise ArgumentError, "'right' for 'hour' must >= 0 and <= 23"
      end
    end
  end

  def hash
    super + '_' + left.to_s
  end

end