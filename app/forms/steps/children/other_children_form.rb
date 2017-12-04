module Steps
  module Children
    class OtherChildrenForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :other_children
    end
  end
end
