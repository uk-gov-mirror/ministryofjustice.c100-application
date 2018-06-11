module C100App
  class SolicitorDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :solicitor_details
        edit(:solicitor_contact_details)
      when :solicitor_contact_details
        edit('/steps/respondent/names')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
