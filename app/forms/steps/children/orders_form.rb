module Steps
  module Children
    class OrdersForm < BaseForm
      attributes PetitionOrder.values, Boolean

      # We override the getter methods for each of the order attributes so we
      # can retrieve their state (checked/unchecked) from the DB array column.
      attribute_names.each do |name|
        define_method(name) { child_order.orders.include?(name.to_s) }
      end

      private

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
