module Steps
  module International
    class ResidentForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :international_resident
    end
  end
end
