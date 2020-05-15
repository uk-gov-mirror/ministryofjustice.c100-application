module Steps
  module Abduction
    class PassportDetailsController < Steps::AbductionStepController
      def edit
        @form_object = PassportDetailsForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(PassportDetailsForm, as: :passport_details)
      end

      private

      def additional_permitted_params
        [passport_possession: []]
      end
    end
  end
end
