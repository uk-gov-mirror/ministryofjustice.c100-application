module Summary
  module Sections
    class AttendingCourt < BaseSectionPresenter
      def name
        :attending_court
      end

      def show_header?
        false
      end

      def answers
        [
          Separator.new(:language_assistance),
          Answer.new(:language_help, c100.language_help),
          FreeTextAnswer.new(:language_help_details, c100.language_help_details),
          Separator.new(:intermediary),
          # TODO: `intermediary` pending until we have these steps in the app
          Separator.new(:special_assistance),
          Answer.new(:special_assistance, c100.special_assistance),
          FreeTextAnswer.new(:special_assistance_details, c100.special_assistance_details),
          Answer.new(:special_arrangements, c100.special_arrangements),
          FreeTextAnswer.new(:special_arrangements_details, c100.special_arrangements_details),
        ].select(&:show?)
      end
    end
  end
end
