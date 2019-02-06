module Steps
  module Screener
    class ParentForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :screener_answers
      yes_no_attribute :parent
    end
  end
end
