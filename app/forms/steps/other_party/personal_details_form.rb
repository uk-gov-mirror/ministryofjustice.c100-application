module Steps
  module OtherParty
    class PersonalDetailsForm < BaseForm
      attribute :has_previous_name, YesNoUnknown
      attribute :previous_name, StrippedString
      attribute :gender, GenderAttribute
      attribute :dob, MultiParamDate
      attribute :dob_unknown, Boolean
      attribute :age_estimate, StrippedString

      validates_inclusion_of :has_previous_name, in: GenericYesNoUnknown.values
      validates_presence_of  :previous_name, if: -> { has_previous_name&.yes? }

      validates_inclusion_of :gender, in: Gender.values

      validates_presence_of  :dob, unless: :dob_unknown?
      validates :dob, sensible_date: true, unless: :dob_unknown?

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        party = c100_application.other_parties.find_or_initialize_by(id: record_id)
        party.update(
          attributes_map
        )
      end
    end
  end
end
