module Steps
  module Petition
    class OrdersForm < BaseForm
      include HasOneAssociationForm
      include OrderAttributes

      has_one_association :asking_order

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
