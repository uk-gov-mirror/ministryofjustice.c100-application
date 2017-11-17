module C100App
  class CourtOrdersDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :has_court_orders
        after_has_court_orders
      when :orders_details
        show('/steps/children/instructions') # TODO: change when we have the next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_has_court_orders
      case step_params.fetch(:has_court_orders)
      when GenericYesNo::YES.to_s
        edit(:details)
      else
        show('/steps/children/instructions') # TODO: change when we have the next step
      end
    end
  end
end
