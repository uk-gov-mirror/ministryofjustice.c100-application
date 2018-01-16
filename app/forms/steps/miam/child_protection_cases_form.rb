module Steps
  module Miam
    class ChildProtectionCasesForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :child_protection_cases
    end
  end
end
