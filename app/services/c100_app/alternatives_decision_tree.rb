module C100App
  class AlternativesDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :negotiation_tools
        edit(:mediation)
      when :mediation
        edit(:lawyer_negotiation)
      when :lawyer_negotiation
        edit(:collaborative_law)
      when :collaborative_law
        edit(:court)
      when :court
        edit('/steps/petition/orders')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
