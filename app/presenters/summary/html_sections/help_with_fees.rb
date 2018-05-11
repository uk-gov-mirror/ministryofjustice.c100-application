module Summary
  module HtmlSections
    class HelpWithFees < Sections::BaseSectionPresenter
      def name
        :help_with_fees
      end

      def answers
        [
          AnswersGroup.new(
            :help_with_fees,
            [
              Answer.new(:help_paying, c100.help_paying),
              FreeTextAnswer.new(:hwf_reference_number, c100.hwf_reference_number),
            ],
            change_path: edit_steps_application_help_paying_path
          )
        ].select(&:show?)
      end
    end
  end
end
