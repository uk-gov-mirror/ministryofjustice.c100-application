module Steps
  module Children
    class OrdersForm < BaseForm
      attribute :orders, Array[String]

      validate :at_least_one_order_validation

      private

      def selected_options
        self[:orders] & PetitionOrder.string_values
      end

      def at_least_one_order_validation
        errors.add(:orders, :blank) unless selected_options.any?
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        child_order.update(
          orders: selected_options
        )
      end

      def child_order
        @_child_order ||= (record.child_order || record.build_child_order)
      end
    end
  end
end
