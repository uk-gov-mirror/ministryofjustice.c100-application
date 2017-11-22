module Steps
  module Miam
    class AcknowledgementController < Steps::MiamStepController
      def edit
        @form_object = AcknowledgementForm.new(
          c100_application: current_c100_application,
          miam_acknowledgement: current_c100_application.miam_acknowledgement
        )
      end

      def update
        update_and_advance(AcknowledgementForm)
      end
    end
  end
end
