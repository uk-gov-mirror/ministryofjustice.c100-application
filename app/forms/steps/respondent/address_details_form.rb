module Steps
  module Respondent
    class AddressDetailsForm < BaseForm
      attribute :address, StrippedString
      attribute :address_unknown, Boolean
      attribute :residence_requirement_met, YesNoUnknown
      attribute :residence_history, String

      validates_presence_of :address, unless: :address_unknown?

      validates_inclusion_of :residence_requirement_met, in: GenericYesNoUnknown.values
      validates_presence_of  :residence_history, if: -> { residence_requirement_met&.no? }

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        respondent = c100_application.respondents.find_or_initialize_by(id: record_id)
        respondent.update(
          attributes_map
        )
      end
    end
  end
end
