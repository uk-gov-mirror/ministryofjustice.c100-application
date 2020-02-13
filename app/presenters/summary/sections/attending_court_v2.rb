module Summary
  module Sections
    class AttendingCourtV2 < BaseSectionPresenter
      def name
        :attending_court
      end

      def show_header?
        false
      end

      # TODO: Temporary conditional reveal until all applications
      # are migrated to the new version
      def show?
        arrangement.present? && super
      end

      def answers
        [
          *language_interpreter,
          *intermediary,
          *special_arrangements,
        ].select(&:show?)
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
        [
          Separator.new(:language_assistance),
          Answer.new(:language_interpreter, arrangement.language_interpreter.to_s),
          FreeTextAnswer.new(:language_interpreter_details, arrangement.language_interpreter_details),
          Answer.new(:sign_language_interpreter, arrangement.sign_language_interpreter.to_s),
          FreeTextAnswer.new(:sign_language_interpreter_details, arrangement.sign_language_interpreter_details),
        ]
      end

      def intermediary
        [
          Separator.new(:intermediary),
          Answer.new(:intermediary_help, arrangement.intermediary_help),
          FreeTextAnswer.new(:intermediary_help_details, arrangement.intermediary_help_details),
        ]
      end

      def special_arrangements
        [
          Separator.new(:special_arrangements),
          MultiAnswer.new(:special_arrangements, arrangement.special_arrangements, show: true),
          FreeTextAnswer.new(:special_arrangements_details, arrangement.special_arrangements_details),
        ]
      end
    end
  end
end
