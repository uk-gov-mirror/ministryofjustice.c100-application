module Steps
  module Respondent
    class RelationshipController < Steps::RespondentStepController
      def edit
        @form_object = RelationshipForm.new(
          c100_application: current_c100_application,
          relationship: current_c100_application.relationship
        )
      end

      def update
        update_and_advance(RelationshipForm)
      end
    end
  end
end
