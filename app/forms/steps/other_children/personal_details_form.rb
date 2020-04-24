module Steps
  module OtherChildren
    class PersonalDetailsForm < BaseForm
      attribute :gender, GenderAttribute
      attribute :dob, MultiParamDate
      attribute :dob_unknown, Boolean
      attribute :age_estimate, StrippedString

      validates_presence_of :dob, unless: :dob_unknown?
      validates_inclusion_of :gender, in: Gender.values

      validates :dob, sensible_date: true, unless: :dob_unknown?

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        child = c100_application.other_children.find_or_initialize_by(id: record_id)
        child.update(
          attributes_map
        )
      end
    end
  end
end
