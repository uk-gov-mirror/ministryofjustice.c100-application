module C100App
  class MiamExemptionsDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :domestic
        edit(:protection)
      when :protection
        edit(:urgency)
      when :urgency
        edit('/steps/petition/orders')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
