module Steps
  module MiamExemptions
    class SafetyController < Steps::MiamExemptionsStepController
      def edit
        @form_object = SafetyForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(SafetyForm, as: :safety)
      end
    end
  end
end
