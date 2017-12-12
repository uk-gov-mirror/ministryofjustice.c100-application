module C100App
  class AlternativesDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :court_acknowledgement
        after_court_acknowledgement
      when :negotiation_tools
        edit(:mediation)
      when :mediation
        edit(:lawyer_negotiation)
      when :lawyer_negotiation
        edit(:collaborative_law)
      when :collaborative_law
        start_children_journey
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_court_acknowledgement
      if has_any_concern?
        show(:start)
      else
        start_children_journey
      end
    end

    def start_children_journey
      edit('/steps/children/names')
    end

    def has_any_concern?
      [
        :risk_of_abduction,
        :substance_abuse,
        :children_abuse,
        :domestic_abuse,
        :other_abuse
      ].any? { |concern| question(concern)&.yes? }
    end
  end
end
