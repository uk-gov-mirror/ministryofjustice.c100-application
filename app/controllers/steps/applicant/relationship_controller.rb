module Steps
  module Applicant
    class RelationshipController < Steps::ApplicantStepController
      def edit
        @form_object = RelationshipForm.build(
          relationship_record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(
          RelationshipForm,
          record: relationship_record,
          as: :relationship
        )
      end

      private

      def child_record
        current_c100_application.children.find(params[:child_id])
      end

      def relationship_record
        current_c100_application.relationships.find_or_initialize_by(
          applicant: current_record, child: child_record
        )
      end
    end
  end
end
