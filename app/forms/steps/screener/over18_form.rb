module Steps
  module Screener
    class Over18Form < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :screener_answers
      yes_no_attribute :over18
    end
  end
end
