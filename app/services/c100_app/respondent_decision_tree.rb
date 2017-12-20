module C100App
  class RespondentDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :add_another_name
        edit(:names)
      when :names_finished
        edit(:personal_details, id: next_respondent_id)
      when :personal_details
        edit(:relationship, id: record, child_id: first_child_id)
      when :relationship
        children_relationships
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
      if next_respondent_id
        edit(:personal_details, id: next_respondent_id)
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

    def children_relationships
      if next_child_id
        edit(:relationship, id: record.respondent, child_id: next_child_id)
      else
        edit(:contact_details, id: record.respondent)
      end
    end

    def next_respondent_id
      next_record_id(c100_application.respondent_ids)
    end

    def next_child_id
      next_record_id(c100_application.child_ids, current: record.child)
    end

    def first_child_id
      c100_application.child_ids.first
    end
  end
end
