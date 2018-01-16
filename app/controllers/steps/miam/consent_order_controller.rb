module Steps
  module Miam
    class ConsentOrderController < Steps::MiamStepController
      include StartingPointStep

      def edit
        @form_object = ConsentOrderForm.new(
          c100_application: current_c100_application,
          consent_order: current_c100_application.consent_order
        )
      end

      def update
        update_and_advance(ConsentOrderForm)
      end
    end
  end
end
