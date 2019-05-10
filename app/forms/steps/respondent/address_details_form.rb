module Steps
  module Respondent
    class AddressDetailsForm < AddressBaseForm
      attribute :residence_requirement_met, YesNoUnknown
      attribute :residence_history, String

      validates_inclusion_of :residence_requirement_met, in: GenericYesNoUnknown.values
      validates_presence_of :residence_history, if: -> { residence_requirement_met&.no? }

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        respondent = c100_application.respondents.find_or_initialize_by(id: record_id)
        respondent.update(
          update_values.merge(
            residence_requirement_met: residence_requirement_met,
            residence_history: residence_history,
          )
        )
      end
    end
  end
end