module Steps
  module Children
    class HasOtherChildrenForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :has_other_children
    end
  end
end
