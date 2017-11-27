module Steps
  module SafetyQuestions
    class RiskOfAbductionForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :risk_of_abduction
    end
  end
end
