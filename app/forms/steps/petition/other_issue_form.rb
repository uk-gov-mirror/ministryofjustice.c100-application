module Steps
  module Petition
    class OtherIssueForm < BaseForm
      attribute :other_details, String
      attribute :child_arrangements_order, Boolean
      attribute :prohibited_steps_order, Boolean
      attribute :specific_issue_order, Boolean

      validates_presence_of :other_details

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
