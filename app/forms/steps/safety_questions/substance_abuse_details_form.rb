module Steps
  module SafetyQuestions
    class SubstanceAbuseDetailsForm < BaseForm
      attribute :substance_abuse_details, String

      validates_presence_of :substance_abuse_details

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          substance_abuse_details: substance_abuse_details
        )
      end
    end
  end
end
