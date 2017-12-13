module Steps
  module Petition
    class OtherIssueForm < BaseForm
      include HasOneAssociationForm

      has_one_association :asking_order

      attribute :other_details, String
      attribute :child_arrangements_order, Boolean
      attribute :prohibited_steps_order, Boolean
      attribute :specific_issue_order, Boolean

      validates_presence_of :other_details

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          attributes_map
        )
      end
    end
  end
end
