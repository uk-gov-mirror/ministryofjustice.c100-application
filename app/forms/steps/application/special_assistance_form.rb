module Steps
  module Application
    class SpecialAssistanceForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :special_assistance,
                       reset_when_no: [:special_assistance_details]

      attribute :special_assistance_details, String

      validates_presence_of :special_assistance_details, if: -> { special_assistance&.yes? }
    end
  end
end
