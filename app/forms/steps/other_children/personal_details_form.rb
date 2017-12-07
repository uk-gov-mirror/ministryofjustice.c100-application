module Steps
  module OtherChildren
    class PersonalDetailsForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :gender, String
      attribute :dob, Date
      attribute :dob_unknown, Boolean

      acts_as_gov_uk_date :dob

      def self.gender_choices
        Gender.string_values
      end
      validates_inclusion_of :gender, in: gender_choices

      validates_presence_of :dob, unless: :dob_unknown?

      private

      def gender_value
        Gender.new(gender)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        child = c100_application.other_children.find_or_initialize_by(id: record_id)
        child.update(
          # Some attributes are value objects and thus we need to provide their values
          attributes_map.merge(
            gender: gender_value
          )
        )
      end
    end
  end
end
