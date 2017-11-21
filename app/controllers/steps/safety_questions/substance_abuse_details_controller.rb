module Steps
  module SafetyQuestions
    class SubstanceAbuseDetailsController < Steps::SafetyQuestionsStepController
      def edit
        @form_object = SubstanceAbuseDetailsForm.new(
          c100_application: current_c100_application,
          substance_abuse_details: current_c100_application.substance_abuse_details
        )
      end

      def update
        update_and_advance(SubstanceAbuseDetailsForm)
      end
    end
  end
end
