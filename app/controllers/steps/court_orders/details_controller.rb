module Steps
  module CourtOrders
    class DetailsController < Steps::CourtOrdersStepController
      def edit
        @form_object = DetailsForm.build(
          orders_record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(DetailsForm, as: :orders_details)
      end

      private

      def orders_record
        current_c100_application.court_order || current_c100_application.build_court_order
      end
    end
  end
end
