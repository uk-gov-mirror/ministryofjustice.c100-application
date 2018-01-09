module Steps
  module Children
    class ResidenceForm < BaseForm
      attribute :person_ids, Array[String]
      attribute :other, Boolean
      attribute :other_full_name, StrippedString

      validates_presence_of :other_full_name, if: :other?

      # These are all the parties available to choose from
      def people
        [
          c100_application.applicants,
          c100_application.respondents,
          c100_application.other_parties
        ].flatten
      end

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record.update(
          person_ids: person_ids,
          other: other,
          other_full_name: (other_full_name if other)
        )
      end
    end
  end
end
