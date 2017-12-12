module Steps
  module Petition
    class OrdersForm < BaseForm
      attribute :child_home, Boolean
      attribute :child_times, Boolean
      attribute :child_contact, Boolean

      attribute :child_specific_issue, Boolean
      attribute :child_specific_issue_school, Boolean
      attribute :child_specific_issue_religion, Boolean
      attribute :child_specific_issue_name, Boolean
      attribute :child_specific_issue_medical, Boolean
      attribute :child_specific_issue_abroad, Boolean

      attribute :child_return, Boolean
      attribute :child_abduction, Boolean
      attribute :child_flight, Boolean

      attribute :other, Boolean

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        asking_order = c100_application.asking_order || c100_application.build_asking_order
        asking_order.update(
          attributes_map
        )
      end
    end
  end
end
