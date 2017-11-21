module Steps
  module SafetyQuestions
    class SubstanceAbuseController < Steps::SafetyQuestionsStepController
      def edit
        @form_object = SubstanceAbuseForm.new(
          c100_application: current_c100_application,
          substance_abuse: current_c100_application.substance_abuse
        )
      end

      def update
        update_and_advance(SubstanceAbuseForm)
      end
    end
  end
end
