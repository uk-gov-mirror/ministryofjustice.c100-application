module C100App
  class PostcodeScreenDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name

      when :children_postcodes
        check_if_court_is_valid
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private 

    def check_if_court_is_valid
      
    end
  end
end
