module C100App
  class RespondentDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
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
        edit('/steps/respondent/names') # TODO: change when we have `other parties` journey
      end
    end

    def next_record_id
      super(c100_application.respondent_ids)
    end
  end
end
