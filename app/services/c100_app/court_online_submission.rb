module C100App
  class CourtOnlineSubmission < BaseOnlineSubmission
    def process
      generate_documents && deliver_email && audit_data
    end

    def to_address
      c100_application.screener_answers_court.email
    end

    private

    def generate_documents
      documents.store(
        :bundle, generate_pdf(:c100, :c1a, :c8)
      )
      # TODO: in a follow-up PR we will split the C8 form
      # documents.store(
      #   :c8_form, generate_pdf(:c8)
      # )
    end

    def deliver_email
      NotifySubmissionMailer.with(application_details).application_to_court(
        to_address: to_address
      ).deliver_now
    end

    def audit_data
      c100_application.email_submission.update(
        to_address: to_address, sent_at: Time.current
      )
    end
  end
end
