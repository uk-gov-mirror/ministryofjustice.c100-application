module Steps
  module Respondent
    class HasOtherPartiesForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :has_other_parties
    end
  end
end
