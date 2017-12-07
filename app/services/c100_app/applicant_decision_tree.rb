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
        after_names_finished
      when :personal_details
        after_personal_details
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_names_finished
      edit(:personal_details, id: next_record)
    end

    def after_personal_details
      if next_record
        edit(:personal_details, id: next_record)
      else
        edit('/steps/respondent/personal_details') # TODO: change when we have next steps
      end
    end

    def next_record
      @_next_record ||= begin
        ids = c100_application.applicant_ids

        return ids.first if record.nil?

        pos = ids.index(record.id)
        ids.at(pos + 1)
      end
    end
  end
end
