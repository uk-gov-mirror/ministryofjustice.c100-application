module Steps
  module Application
    class UrgentHearingForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :urgent_hearing
    end
  end
end
