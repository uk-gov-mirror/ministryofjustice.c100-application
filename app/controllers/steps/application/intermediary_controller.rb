module Steps
  module Application
    class IntermediaryController < Steps::ApplicationStepController
      def edit
        @form_object = IntermediaryForm.build(current_c100_application)
      end

      def update
        update_and_advance(IntermediaryForm, as: :intermediary)
      end
    end
  end
end
