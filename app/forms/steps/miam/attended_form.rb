module Steps
  module Miam
    class AttendedForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :miam_attended, reset_when_no: [
        :miam_certification,
        :miam_certification_date,
        :miam_certification_number,
        :miam_certification_service_name,
        :miam_certification_sole_trader_name
      ]
    end
  end
end
