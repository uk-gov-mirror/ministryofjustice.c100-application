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
      when :has_other_parties
        after_has_other_parties
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_contact_details
      if next_record_id
        edit(:personal_details, id: next_record_id)
      else
        edit(:has_other_parties)
      end
    end

    def after_has_other_parties
      if question(:has_other_parties).yes?
        edit('/steps/other_parties/names')
      else
        edit('/steps/abuse_concerns/previous_proceedings') # TODO: change when we have children residence step
      end
    end

    def next_record_id
      super(c100_application.respondent_ids)
    end
  end
end
