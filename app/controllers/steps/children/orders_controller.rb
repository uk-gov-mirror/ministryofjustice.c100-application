module Steps
  module Children
    class OrdersController < Steps::ChildrenStepController
      def edit
        @form_object = OrdersForm.new(
          c100_application: current_c100_application,
          record: current_record
        )

        @petition = PetitionPresenter.new(
          current_c100_application
        )
      end

      def update
        update_and_advance(
          OrdersForm,
          record: current_record,
          as: :orders
        )
      end
    end
  end
end
