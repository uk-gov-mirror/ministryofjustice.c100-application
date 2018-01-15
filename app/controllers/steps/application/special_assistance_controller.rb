module Steps
  module Application
    class SpecialAssistanceController < Steps::ApplicationStepController
      def edit
        @form_object = SpecialAssistanceForm.build(current_c100_application)
      end

      def update
        update_and_advance(SpecialAssistanceForm, as: :special_assistance)
      end
    end
  end
end
