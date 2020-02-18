module Summary
  module HtmlSections
    class AttendingCourt < Sections::BaseSectionPresenter
      def name
        :attending_court
      end

      # TODO: Temporary conditional reveal until all applications
      # are migrated to the new version
      def show?
        arrangement.nil? && super
      end

      def answers
        [
          intermediary,
          language_assistance,
          special_arrangements,
          special_assistance,
        ].flatten.select(&:show?)
      end

      private

      def arrangement
        @_arrangement ||= c100.court_arrangement
      end

      def language_assistance
        AnswersGroup.new(
          :language_help,
          [
            Answer.new(:language_help, c100.language_help),
            FreeTextAnswer.new(:language_help_details, c100.language_help_details),
          ],
          change_path: edit_steps_application_language_path
        )
      end

      def intermediary
        AnswersGroup.new(
          :intermediary,
          [
            Answer.new(:intermediary_help, c100.intermediary_help),
            FreeTextAnswer.new(:intermediary_help_details, c100.intermediary_help_details),
          ],
          change_path: edit_steps_application_intermediary_path
        )
      end

      def special_arrangements
        AnswersGroup.new(
          :special_arrangements,
          [
            Answer.new(:special_arrangements, c100.special_arrangements),
            FreeTextAnswer.new(:special_arrangements_details, c100.special_arrangements_details),
          ],
          change_path: edit_steps_application_special_arrangements_path
        )
      end

      def special_assistance
        AnswersGroup.new(
          :special_assistance,
          [
            Answer.new(:special_assistance, c100.special_assistance),
            FreeTextAnswer.new(:special_assistance_details, c100.special_assistance_details),
          ],
          change_path: edit_steps_application_special_assistance_path
        )
      end
    end
  end
end
