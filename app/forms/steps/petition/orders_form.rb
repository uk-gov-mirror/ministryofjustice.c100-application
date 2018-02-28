module Steps
  module Petition
    class OrdersForm < BaseForm
      attributes PetitionOrder.values, Boolean

      # We override the getter methods for each of the order attributes so we
      # can retrieve their state (checked/unchecked) from the DB array column.
      attribute_names.each do |name|
        define_method(name) { c100_application.orders.include?(name.to_s) }
      end

      # We also need an attribute to hold details when `other_issue` checkbox
      # is selected. This attribute should not have its getter overridden.
      attribute :orders_additional_details, String

      # TODO: validation

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          orders: selected_options,
          orders_additional_details: orders_additional_details,
        )
      end
    end
  end
end
