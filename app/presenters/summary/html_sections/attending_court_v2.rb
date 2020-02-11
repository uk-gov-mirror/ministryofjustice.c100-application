module Summary
  module HtmlSections
    class AttendingCourtV2 < Sections::BaseSectionPresenter
      def name
        :attending_court
      end

      # TODO: Temporary conditional reveal until all applications
      # are migrated to the new version
      def show?
        arrangement.present? && super
      end

      def answers
        [
          language_interpreter,
        ].flatten.select(&:show?)
      end

      private

      def arrangement
        @_arrangement ||= c100.court_arrangement
      end

      # Note: we convert the booleans in the `Answer` object with `to_s`, so `true` and `false`
      # are true for `#present?` but not for nil (''), meaning if the user didn't reach this
      # question yet, the value will be `nil` and `Answer` will not show, but once they reach
      # this question and continue, it will become `true` or `false`, and we want it to show
      # (even if it is `false` i.e. checkbox not selected).
      #
      def language_interpreter
        AnswersGroup.new(
          :language_interpreter,
          [
            Answer.new(:language_interpreter, arrangement.language_interpreter.to_s),
            FreeTextAnswer.new(:language_interpreter_details, arrangement.language_interpreter_details),
            Answer.new(:sign_language_interpreter, arrangement.sign_language_interpreter.to_s),
            FreeTextAnswer.new(:sign_language_interpreter_details, arrangement.sign_language_interpreter_details),
          ],
          change_path: edit_steps_attending_court_language_path
        )
      end
    end
  end
end
