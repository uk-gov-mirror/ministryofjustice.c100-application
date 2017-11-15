module Steps
  module CourtOrders
    class HasOrdersForm < BaseForm
      attribute :has_court_orders, String

      def self.choices
        GenericYesNo.string_values
      end
      validates_inclusion_of :has_court_orders, in: choices

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          has_court_orders: GenericYesNo.new(has_court_orders)
        )
      end
    end
  end
end
