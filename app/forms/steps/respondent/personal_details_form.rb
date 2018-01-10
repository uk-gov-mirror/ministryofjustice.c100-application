module Steps
  module Respondent
    class PersonalDetailsForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :has_previous_name, YesNoUnknown
      attribute :previous_name, StrippedString
      attribute :gender, String
      attribute :dob, Date
      attribute :dob_unknown, Boolean
      attribute :age_estimate, StrippedString
      attribute :birthplace, StrippedString

      acts_as_gov_uk_date :dob

      def self.gender_choices
        Gender.string_values
      end
      validates_inclusion_of :gender, in: gender_choices

      validates_inclusion_of :has_previous_name, in: GenericYesNoUnknown.values
      validates_presence_of  :previous_name, if: -> { has_previous_name&.yes? }
      validates_presence_of  :dob, unless: :dob_unknown?

      private

      def gender_value
        Gender.new(gender)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        respondent = c100_application.respondents.find_or_initialize_by(id: record_id)
        respondent.update(
          # Some attributes are value objects and thus we need to provide their values,
          # but eventually we may end up with the same solution as for `YesNo` attributes.
          attributes_map.merge(
            gender: gender_value
          )
        )
      end
    end
  end
end
