module Steps
  module Application
    class WithoutNoticeForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :without_notice
    end
  end
end
