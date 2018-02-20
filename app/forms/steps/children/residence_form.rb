module Steps
  module Children
    class ResidenceForm < BaseForm
      attribute :person_ids, Array[String]

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
        )
      end
    end
  end
end
