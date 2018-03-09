module Steps
  module Miam
    class ConsentOrderController < Steps::MiamStepController
      #
      # NOTE: this step is not used for now, as we are screening out people,
      # but we don't want to remove it as it is valid and will be activated
      # as soon as we can.
      #
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
