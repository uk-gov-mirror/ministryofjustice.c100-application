module Steps
  module Petition
    class OtherIssueController < Steps::PetitionStepController
      def edit
        @form_object = OtherIssueForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(OtherIssueForm, as: :other_issue)
      end
    end
  end
end
