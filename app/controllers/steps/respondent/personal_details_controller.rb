module Steps
  module Respondent
    class PersonalDetailsController < Steps::RespondentStepController
      include CrudStep

      def edit
        @form_object = PersonalDetailsForm.build(
          current_record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(
          PersonalDetailsForm,
          record: current_record,
          as: params.fetch(:button, :respondents_finished)
        )
      end

      private

      def record_collection
        @_record_collection ||= current_c100_application.respondents
      end
    end
  end
end
