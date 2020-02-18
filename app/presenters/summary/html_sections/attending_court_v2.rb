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
          intermediary,
          language_interpreter,
          special_arrangements,
          special_assistance,
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

      # Note: we convert the booleans in the `Answer` object with `to_s`, so `true` and `false`
      # are both true for `#present?` as we want to show this question even if it is `false`
      # i.e. checkbox was not selected. If `language_options` is `nil`, it means the user didn't
      # yet reach this step and only in that case we skip this block.
      #
      def language_interpreter
        # Do not show this block in CYA if the user didn't yet reach this step
        # (we know because the array will be `nil` in that case).
        return [] if arrangement.language_options.nil?

        AnswersGroup.new(
          :language_interpreter,
          [
            Answer.new(
              :language_interpreter,
              arrangement.language_options.include?(LanguageHelp::LANGUAGE_INTERPRETER.to_s).to_s
            ),
            FreeTextAnswer.new(:language_interpreter_details, arrangement.language_interpreter_details),
            Answer.new(
              :sign_language_interpreter,
              arrangement.language_options.include?(LanguageHelp::SIGN_LANGUAGE_INTERPRETER.to_s).to_s
            ),
            FreeTextAnswer.new(:sign_language_interpreter_details, arrangement.sign_language_interpreter_details),
          ],
          change_path: edit_steps_attending_court_language_path
        )
      end

      def special_arrangements
        # Do not show this block in CYA if the user didn't yet reach this step
        # (we know because the array will be `nil` in that case).
        return [] if arrangement.special_arrangements.nil?

        AnswersGroup.new(
          :special_arrangements,
          [
            MultiAnswer.new(:special_arrangements, arrangement.special_arrangements, show: true),
            FreeTextAnswer.new(:special_arrangements_details, arrangement.special_arrangements_details),
          ],
          change_path: edit_steps_attending_court_special_arrangements_path
        )
      end

      def special_assistance
        # Do not show this block in CYA if the user didn't yet reach this step
        # (we know because the array will be `nil` in that case).
        return [] if arrangement.special_assistance.nil?

        AnswersGroup.new(
          :special_assistance,
          [
            MultiAnswer.new(:special_assistance, arrangement.special_assistance, show: true),
            FreeTextAnswer.new(:special_assistance_details, arrangement.special_assistance_details),
          ],
          change_path: edit_steps_attending_court_special_assistance_path
        )
      end
    end
  end
end
