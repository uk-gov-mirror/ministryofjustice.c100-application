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

      validate :at_least_one_order
      validate :at_least_one_prohibited_steps_order
      validate :at_least_one_specific_issues_order

      validates_presence_of :orders_additional_details, if: :other_issue?

      private

      def at_least_one_order
        errors.add(:base, :blank_orders) unless selected_options.any?
      end

      def at_least_one_prohibited_steps_order
        return unless group_prohibited_steps?

        errors.add(
          PetitionOrder::GROUP_PROHIBITED_STEPS.to_sym, :blank_orders
        ) unless selected_options.grep(/\Aprohibited_steps/).any?
      end

      def at_least_one_specific_issues_order
        return unless group_specific_issues?

        errors.add(
          PetitionOrder::GROUP_SPECIFIC_ISSUES.to_sym, :blank_orders
        ) unless selected_options.grep(/\Aspecific_issues/).any?
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
