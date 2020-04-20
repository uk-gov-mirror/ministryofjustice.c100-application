module Steps
  module Petition
    class OrdersController < Steps::PetitionStepController
      def edit
        @form_object = OrdersForm.build(current_c100_application)
      end

      def update
        update_and_advance(OrdersForm, as: :orders)
      end

      private

      def additional_permitted_params
        [orders: [], orders_collection: []]
      end
    end
  end
end
