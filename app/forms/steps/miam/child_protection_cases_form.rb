module Steps
  module Miam
    class ChildProtectionCasesForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :child_protection_cases,
                       reset_when_yes: [
                         :miam_acknowledgement,
                         :miam_attended,
                         :miam_exemption_claim,
                         :miam_certification,
                         Steps::Miam::CertificationDateForm,
                         Steps::Miam::CertificationDetailsForm,
                       ]
    end
  end
end
