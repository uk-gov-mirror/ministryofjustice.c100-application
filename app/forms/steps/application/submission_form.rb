module Steps
  module Application
    class SubmissionForm < BaseForm
      attribute :submission_type, String
      attribute :receipt_email, NormalisedEmail

      validates_inclusion_of :submission_type, in: SubmissionType.string_values
      validates :receipt_email, email: true, allow_blank: true

      private

      def online_submission?
        submission_type.eql?(SubmissionType::ONLINE.to_s)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          submission_type: submission_type,
          receipt_email: (receipt_email if online_submission?),
        )
      end
    end
  end
end
