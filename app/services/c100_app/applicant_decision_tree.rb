module C100App
  class ApplicantDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :user_type
        edit(:number_of_children)
      when :number_of_children
        edit('/steps/help_with_fees/help_paying')
      when :personal_details, :add_another_applicant
        edit(:personal_details)
      when :applicants_finished
        edit('/steps/respondent/personal_details')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
