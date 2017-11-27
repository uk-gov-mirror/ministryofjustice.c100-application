module Steps
  module Petition
    class OtherIssueController < Steps::PetitionStepController
      def edit
        @form_object = OtherIssueForm.build(
          record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(OtherIssueForm, as: :other_issue)
      end

      private

      def record
        current_c100_application.asking_order || current_c100_application.build_asking_order
      end
    end
  end
end
