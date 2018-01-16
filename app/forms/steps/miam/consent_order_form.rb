module Steps
  module Miam
    class ConsentOrderForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :consent_order
    end
  end
end
