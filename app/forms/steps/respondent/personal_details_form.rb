module Steps
  module Respondent
    class PersonalDetailsForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :full_name, StrippedString
      attribute :has_previous_name, String
      attribute :previous_full_name, StrippedString
      attribute :gender, String
      attribute :dob, Date
      attribute :dob_unknown, Boolean
      attribute :birthplace, StrippedString
      attribute :address, StrippedString
      attribute :postcode, StrippedString
      attribute :postcode_unknown, Boolean
      attribute :home_phone, StrippedString
      attribute :mobile_phone, StrippedString
      attribute :mobile_phone_unknown, Boolean
      attribute :email, NormalisedEmail
      attribute :email_unknown, Boolean

      acts_as_gov_uk_date :dob

      def self.has_previous_name_choices
        GenericYesNoUnknown.string_values
      end
      validates_inclusion_of :has_previous_name, in: has_previous_name_choices

      def self.gender_choices
        Gender.string_values
      end
      validates_inclusion_of :gender, in: gender_choices

      validates_presence_of :full_name, :address, :home_phone
      validates_presence_of :previous_full_name, if: :has_previous_name?

      # Validations -unless- 'I don't know checkbox' is selected
      validates_presence_of :dob,      unless: :dob_unknown?
      validates_presence_of :postcode, unless: :postcode_unknown?
      validates :email, email: true,   unless: :email_unknown?

      private

      def has_previous_name?
        has_previous_name.eql?(GenericYesNoUnknown::YES.to_s)
      end

      def has_previous_name_value
        GenericYesNoUnknown.new(has_previous_name)
      end

      def gender_value
        Gender.new(gender)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        respondent = c100_application.respondents.find_or_initialize_by(id: record_id)
        respondent.update(
          # Some attributes are value objects and thus we need to provide their values
          attributes_map.merge(
            has_previous_name: has_previous_name_value,
            gender: gender_value
          )
        )
      end
    end
  end
end
