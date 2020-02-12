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
          litigation_capacity,
          language_interpreter,
          intermediary,
        ].flatten.select(&:show?)
      end

      private

      def arrangement
        @_arrangement ||= c100.court_arrangement
      end

      # Note: this for now maintains the same DB model as before (dupe from `AttendingCourt`)
      # To be evaluated if it is worth move the fields to the new `court_arrangements` table.
      def litigation_capacity
        [
          Answer.new(
            :reduced_litigation_capacity,
            c100.reduced_litigation_capacity,
            change_path: edit_steps_application_litigation_capacity_path
          ),
          AnswersGroup.new(
            :litigation_capacity,
            [
              FreeTextAnswer.new(:participation_capacity_details, c100.participation_capacity_details),
              FreeTextAnswer.new(:participation_other_factors_details, c100.participation_other_factors_details),
              FreeTextAnswer.new(:participation_referral_or_assessment_details, c100.participation_referral_or_assessment_details),
            ],
            change_path: edit_steps_application_litigation_capacity_details_path
          )
        ]
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

      def intermediary
        AnswersGroup.new(
          :intermediary,
          [
            Answer.new(:intermediary_help, arrangement.intermediary_help),
            FreeTextAnswer.new(:intermediary_help_details, arrangement.intermediary_help_details),
          ],
          change_path: edit_steps_attending_court_intermediary_path
        )
      end
    end
  end
end
