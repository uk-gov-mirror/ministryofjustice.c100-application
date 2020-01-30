module C100App
  class ApplicantDecisionTree < PeopleDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :add_another_name
        edit(:names)
      when :names_finished
        edit(:personal_details, id: next_applicant_id)
      when :personal_details
        after_personal_details
      when :under_age
        edit_first_child_relationships
      when :relationship
        children_relationships
      when :address_details
        edit_contact_details
      when :contact_details
        after_contact_details
      when :has_solicitor
        after_has_solicitor
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_contact_details
      if next_applicant_id
        edit(:personal_details, id: next_applicant_id)
      elsif show_solicitor_journey?
        edit(:has_solicitor)
      else
        edit('/steps/respondent/names')
      end
    end

    def after_has_solicitor
      if question(:has_solicitor).yes?
        edit('/steps/solicitor/personal_details')
      else
        edit('/steps/respondent/names')
      end
    end

    def next_applicant_id
      next_record_id(c100_application.applicant_ids)
    end

    # TODO: leave this until all applications are migrated to version >= 4
    def show_solicitor_journey?
      c100_application.version >= 4
    end
  end
end
