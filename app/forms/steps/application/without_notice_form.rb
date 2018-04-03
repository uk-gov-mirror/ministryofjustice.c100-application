module Steps
  module Application
    class WithoutNoticeForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :without_notice, reset_when_no: [
        :without_notice_details,
        :without_notice_frustrate,
        :without_notice_frustrate_details,
        :without_notice_impossible,
        :without_notice_impossible_details,
      ]
    end
  end
end
