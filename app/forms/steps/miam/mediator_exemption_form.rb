module Steps
  module Miam
    class MediatorExemptionForm < BaseForm
      include SingleQuestionForm

      # The reset will delete the row from the `miam_exemptions` table
      yes_no_attribute :miam_mediator_exemption,
                       reset_when_yes: [:miam_exemption_claim, :miam_exemption]
    end
  end
end
