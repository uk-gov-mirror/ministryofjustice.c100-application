module Steps
  module Application
    class HelpPayingForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :help_paying, reset_when_no: [:hwf_reference_number]

      attribute :hwf_reference_number, StrippedString

      validates_presence_of :hwf_reference_number, if: -> { help_paying&.yes? }
    end
  end
end
