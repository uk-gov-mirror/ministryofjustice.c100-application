module C100App
  class ApplicantDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :user_type
        edit(:number_of_children)
      when :number_of_children
        edit('/steps/help_with_fees/help_paying')
      when :add_another_name
        edit(:names)
      when :names_finished
        edit(:personal_details, id: next_record_id)
      when :personal_details
        edit(:contact_details, id: record)
      when :contact_details
        after_contact_details
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_contact_details
      if next_record_id
        edit(:personal_details, id: next_record_id)
      else
        edit('/steps/respondent/names')
      end
    end

    def next_record_id
      super(c100_application.applicant_ids)
    end
  end
end
