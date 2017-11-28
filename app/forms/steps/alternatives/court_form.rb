module Steps
  module Alternatives
    class CourtForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :alternative_court
    end
  end
end
