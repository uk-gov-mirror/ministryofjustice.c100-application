module Summary
  module HtmlSections
    class RespondentsDetails < PeopleDetails
      def name
        :respondents_details
      end

      def record_collection
        c100.respondents
      end

      protected

      def names_path
        edit_steps_respondent_names_path(id: '')
      end

      def personal_details_path(person)
        edit_steps_respondent_personal_details_path(person)
      end

      def contact_details_path(person)
        edit_steps_respondent_contact_details_path(person)
      end
    end
  end
end
