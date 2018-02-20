module Steps
  module Children
    class PersonalDetailsForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :gender, GenderAttribute
      attribute :dob, Date
      attribute :dob_unknown, Boolean
      attribute :age_estimate, StrippedString

      acts_as_gov_uk_date :dob

      validates_inclusion_of :gender, in: Gender.values
      validates_presence_of :dob, unless: :dob_unknown?

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        child = c100_application.children.find_or_initialize_by(id: record_id)
        child.update(
          attributes_map
        )
      end
    end
  end
end
