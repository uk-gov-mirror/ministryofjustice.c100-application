module Steps
  module CourtOrders
    class HasOrdersForm < BaseForm
      attribute :has_court_orders, YesNo

      validates_inclusion_of :has_court_orders, in: GenericYesNo.values

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          has_court_orders: has_court_orders
        )
      end
    end
  end
end
