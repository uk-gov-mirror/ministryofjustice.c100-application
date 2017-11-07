module Steps
  module Children
    class PersonalDetailsForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :full_name, StrippedString
      attribute :gender, String
      attribute :dob, Date
      attribute :dob_unknown, Boolean
      attribute :orders_applied_for, String
      attribute :applicants_relationship, String
      attribute :respondents_relationship, String

      acts_as_gov_uk_date :dob

      def self.gender_choices
        Gender.values.map(&:to_s)
      end
      validates_inclusion_of :gender, in: gender_choices

      validates_presence_of :dob, unless: :dob_unknown?

      validates_presence_of :full_name,
                            :orders_applied_for,
                            :applicants_relationship,
                            :respondents_relationship

      private

      def gender_value
        Gender.new(gender)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        applicant = c100_application.children.find_or_initialize_by(id: record_id)
        applicant.update(
          # Some attributes are value objects and thus we need to provide their values
          attributes_map.merge(
            gender: gender_value
          )
        )
      end
    end
  end
end
