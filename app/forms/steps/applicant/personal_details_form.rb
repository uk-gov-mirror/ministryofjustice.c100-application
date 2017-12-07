module Steps
  module Applicant
    class PersonalDetailsForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :has_previous_name, YesNo
      attribute :previous_name, StrippedString
      attribute :gender, String
      attribute :dob, Date
      attribute :birthplace, StrippedString

      acts_as_gov_uk_date :dob

      validates_inclusion_of :has_previous_name, in: GenericYesNo.values

      def self.gender_choices
        Gender.string_values
      end
      validates_inclusion_of :gender, in: gender_choices

      validates_presence_of :birthplace, :dob
      validates_presence_of :previous_name, if: -> { has_previous_name&.yes? }

      private

      def gender_value
        Gender.new(gender)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        applicant = c100_application.applicants.find_or_initialize_by(id: record_id)
        applicant.update(
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
