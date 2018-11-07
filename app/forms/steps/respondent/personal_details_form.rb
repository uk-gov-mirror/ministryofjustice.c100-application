module Steps
  module Respondent
    class PersonalDetailsForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :has_previous_name, YesNoUnknown
      attribute :previous_name, StrippedString
      attribute :gender, GenderAttribute
      attribute :dob, Date
      attribute :dob_unknown, Boolean
      attribute :age_estimate, StrippedString
      attribute :birthplace, StrippedString

      acts_as_gov_uk_date :dob

      validates_inclusion_of :gender, in: Gender.values
      validates_inclusion_of :has_previous_name, in: GenericYesNoUnknown.values

      validates_presence_of  :previous_name, if: -> { has_previous_name&.yes? }
      validates_presence_of  :dob, unless: :dob_unknown?

      validates :dob, sensible_date: true, unless: :dob_unknown?

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
