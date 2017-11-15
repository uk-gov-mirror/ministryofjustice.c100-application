module C100App
  class CourtOrdersDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      # TODO: not doing yet anything with the `yes` or `no` answer
      case step_name
      when :has_court_orders
        show('/steps/children/instructions') # TODO: change when we have the next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
