module Steps
  module Application
    class SpecialArrangementsForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :special_arrangements,
                       reset_when_no: [:special_arrangements_details]

      attribute :special_arrangements_details, String

      validates_presence_of :special_arrangements_details, if: -> { special_arrangements&.yes? }
    end
  end
end
