module Steps
  module Application
    class IntermediaryForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :intermediary_help, reset_when_no: [:intermediary_help_details]

      attribute :intermediary_help_details, String

      validates_presence_of :intermediary_help_details, if: -> { intermediary_help&.yes? }
    end
  end
end
