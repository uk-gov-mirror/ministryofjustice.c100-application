module Steps
  module AbuseConcerns
    class PreviousProceedingsForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :children_previous_proceedings, reset_when_no: [:emergency_proceedings]
    end
  end
end
