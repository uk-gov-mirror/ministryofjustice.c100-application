module Steps
  module AbuseConcerns
    class EmergencyProceedingsController < Steps::AbuseConcernsStepController
      def edit
        @form_object = EmergencyProceedingsForm.new(
          c100_application: current_c100_application,
          emergency_proceedings: current_c100_application.emergency_proceedings
        )
      end

      def update
        update_and_advance(EmergencyProceedingsForm, as: :emergency_proceedings)
      end
    end
  end
end
