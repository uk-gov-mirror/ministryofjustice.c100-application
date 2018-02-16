module Steps
  module Miam
    class ExemptionClaimForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :miam_exemption_claim
    end
  end
end
