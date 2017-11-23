module Steps
  module Miam
    class AttendedForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :miam_attended
    end
  end
end
