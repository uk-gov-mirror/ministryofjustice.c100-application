module Steps
  module Petition
    class OrdersController < Steps::PetitionStepController
      def edit
        @form_object = OrdersForm.build(
          record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(OrdersForm, as: :orders)
      end

      private

      def record
        current_c100_application.asking_order || current_c100_application.build_asking_order
      end
    end
  end
end
