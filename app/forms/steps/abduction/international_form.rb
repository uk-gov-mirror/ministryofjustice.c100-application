module Steps
  module Abduction
    class InternationalForm < BaseForm
      include HasOneAssociationForm

      has_one_association :abduction_detail

      attribute :international_risk, YesNo
      attribute :passport_office_notified, YesNo
      attribute :children_multiple_passports, YesNo
      attribute :passport_possession_mother, Boolean
      attribute :passport_possession_father, Boolean
      attribute :passport_possession_other, Boolean
      attribute :passport_possession_other_details, String

      validates_inclusion_of :international_risk,
                             :children_multiple_passports, in: GenericYesNo.values

      validates_inclusion_of :passport_office_notified, in: GenericYesNo.values, if: -> { international_risk&.yes? }

      validates_presence_of :passport_possession_other_details, if: :passport_possession_other?
      validates_absence_of  :passport_possession_other_details, unless: :passport_possession_other?

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
