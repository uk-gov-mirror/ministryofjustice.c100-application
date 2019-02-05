module Steps
  module Screener
    class LegalRepresentationForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :screener_answers
      yes_no_attribute :legal_representation
    end
  end
end
