module Steps
  module Applicant
    class PersonalDetailsForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :full_name, StrippedString
      attribute :has_previous_name, String
      attribute :previous_full_name, StrippedString
      attribute :gender, String
      attribute :dob, Date
      attribute :birthplace, StrippedString
      attribute :address, StrippedString
      attribute :postcode, StrippedString
      attribute :home_phone, StrippedString
      attribute :mobile_phone, StrippedString
      attribute :email, NormalisedEmail

      acts_as_gov_uk_date :dob

      def self.has_previous_name_choices
        GenericYesNo.values.map(&:to_s)
      end
      validates_inclusion_of :has_previous_name, in: has_previous_name_choices

      def self.gender_choices
        Gender.values.map(&:to_s)
      end
      validates_inclusion_of :gender, in: gender_choices

      validates :email, email: true
      validates_presence_of :full_name, :birthplace, :dob
      validates_presence_of :previous_full_name, if: :has_previous_name?

      private

      def has_previous_name?
        has_previous_name.eql?(GenericYesNo::YES.to_s)
      end

      def has_previous_name_value
        GenericYesNo.new(has_previous_name)
      end

      def gender_value
        Gender.new(gender)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        applicant = c100_application.applicants.find_or_initialize_by(id: record_id)
        applicant.update(
          full_name: full_name,
          has_previous_name: has_previous_name_value,
          previous_full_name: previous_full_name,
          gender: gender_value,
          dob: dob,
          birthplace: birthplace,
          address: address,
          postcode: postcode,
          home_phone: home_phone,
          mobile_phone: mobile_phone,
          email: email
        )
      end
    end
  end
end
