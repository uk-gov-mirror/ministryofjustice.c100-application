module Steps
  module Applicant
    class HasSolicitorForm < BaseForm
      include SingleQuestionForm

      # The reset will delete the row from the `solicitors` table
      yes_no_attribute :has_solicitor, reset_when_no: [:solicitor]
    end
  end
end
