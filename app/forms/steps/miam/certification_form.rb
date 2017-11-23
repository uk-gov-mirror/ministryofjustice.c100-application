module Steps
  module Miam
    class CertificationForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :miam_certification
    end
  end
end
