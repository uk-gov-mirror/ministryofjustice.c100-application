module Steps
  module Abduction
    class InternationalForm < BaseForm
      include HasOneAssociationForm

      has_one_association :abduction_detail

      attribute :international_risk, YesNo
      attribute :passport_office_notified, YesNo

      validates_inclusion_of :international_risk, in: GenericYesNo.values
      validates_inclusion_of :passport_office_notified, in: GenericYesNo.values, if: -> { international_risk&.yes? }

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
