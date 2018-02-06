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
          *language_assistance_answers,
          *intermediary_answers,
          *special_assistance_answers,
        ].select(&:show?)
      end

      private

      def language_assistance_answers
        [
          Separator.new(:language_assistance),
          Answer.new(:language_help, c100.language_help),
          FreeTextAnswer.new(:language_help_details, c100.language_help_details),
        ]
      end

      def intermediary_answers
        [
          Separator.new(:intermediary),
          Answer.new(:intermediary_help, c100.intermediary_help),
          FreeTextAnswer.new(:intermediary_help_details, c100.intermediary_help_details),
        ]
      end

      def special_assistance_answers
        [
          Separator.new(:special_assistance),
          Answer.new(:special_assistance, c100.special_assistance),
          FreeTextAnswer.new(:special_assistance_details, c100.special_assistance_details),
          Answer.new(:special_arrangements, c100.special_arrangements),
          FreeTextAnswer.new(:special_arrangements_details, c100.special_arrangements_details),
        ]
      end
    end
  end
end
