module Steps
  module Abduction
    class PassportDetailsForm < BaseForm
      include HasOneAssociationForm

      has_one_association :abduction_detail

      attribute :children_multiple_passports, YesNo
      attribute :passport_possession_mother, Boolean
      attribute :passport_possession_father, Boolean
      attribute :passport_possession_other, Boolean
      attribute :passport_possession_other_details, String

      validates_inclusion_of :children_multiple_passports, in: GenericYesNo.values
      validates_presence_of  :passport_possession_other_details, if: :passport_possession_other?

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          attributes_map.merge(
            passport_possession_other_details: (passport_possession_other_details if passport_possession_other?)
          )
        )
      end
    end
  end
end
