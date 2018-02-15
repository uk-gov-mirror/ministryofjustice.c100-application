module Steps
  module Petition
    class OrdersForm < BaseForm
      include HasOneAssociationForm
      has_one_association :asking_order

      attributes PetitionOrder.values, Boolean
      attribute  :other_details, String

      validates_presence_of :other_details, if: :other?

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
