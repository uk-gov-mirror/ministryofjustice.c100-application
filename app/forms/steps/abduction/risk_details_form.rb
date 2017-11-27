module Steps
  module Abduction
    class RiskDetailsForm < BaseForm
      include HasOneAssociationForm

      has_one_association :abduction_detail

      attribute :risk_details, String

      validates_presence_of :risk_details

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record.update(
          attributes_map
        )
      end
    end
  end
end
