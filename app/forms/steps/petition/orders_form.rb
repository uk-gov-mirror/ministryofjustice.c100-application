module Steps
  module Petition
    class OrdersForm < BaseForm
      attributes PetitionOrder.values, Boolean
      attribute :orders_additional_details, String

      # This is a special kind of form-object, storing its attributes not
      # as individual DB fields but in a DB array column instead.
      # We retrieve their state (checked/unchecked) from the DB array column.
      #
      def self.build(c100_application)
        attributes = attribute_names.map { |name| [name, c100_application.orders.include?(name.to_s)] }.to_h

        # Any other attributes needed, add them here, including `c100_application`
        attributes.merge!(
          c100_application: c100_application,
          orders_additional_details: c100_application.orders_additional_details,
        )

        new(attributes)
      end

      validate :at_least_one_checkbox_validation
      validates_presence_of :orders_additional_details, if: :other_issue?

      private

      # We filter out `group_xxx` items, as the purpose of these are to present the orders
      # in groups for the user to show/hide them, and are not really an order by itself.
      #
      def valid_options
        selected_options.grep_v(/\Agroup_/)
      end

      def at_least_one_checkbox_validation
        errors.add(:base, :blank_orders) unless valid_options.any?
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          orders: selected_options,
          orders_additional_details: (orders_additional_details if other_issue?),
        )
      end
    end
  end
end
