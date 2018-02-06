module Steps
  module Application
    class LanguageForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :language_help, reset_when_no: [:language_help_details]

      attribute :language_help_details, String

      validates_presence_of :language_help_details, if: -> { language_help&.yes? }
    end
  end
end
