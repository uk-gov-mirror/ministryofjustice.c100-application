module Steps
  module Children
    class OrdersForm < BaseForm
      include OrderAttributes

      # We override the getter methods for each of the order attributes so we
      # can retrieve their state (checked/unchecked) from the DB array column.
      attribute_set.each do |att|
        define_method(att.name) { child_order.orders.include?(att.name.to_s) }
      end

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        child_order.update(
          orders: selected_orders
        )
      end

      def selected_orders
        attributes_map.select { |_name, selected| selected }.keys
      end

      def child_order
        @_child_order ||= (record.child_order || record.build_child_order)
      end
    end
  end
end
