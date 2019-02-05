module Steps
  module Screener
    class WrittenAgreementForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :screener_answers
      yes_no_attribute :written_agreement
    end
  end
end
