module Steps
  module Applicant
    class HasSolicitorForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :has_solicitor
    end
  end
end
