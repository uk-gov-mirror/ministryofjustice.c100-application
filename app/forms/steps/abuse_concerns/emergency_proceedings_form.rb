module Steps
  module AbuseConcerns
    class EmergencyProceedingsForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :emergency_proceedings
    end
  end
end
