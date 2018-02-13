module Steps
  module AbuseConcerns
    class PreviousProceedingsForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :children_previous_proceedings
    end
  end
end
