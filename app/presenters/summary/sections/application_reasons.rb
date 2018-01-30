module Summary
  module Sections
    class ApplicationReasons < BaseSectionPresenter
      def name
        :application_reasons
      end

      def show_header?
        false
      end

      def answers
        [
          Answer.new(:applied_for_permission, GenericYesNo::NO), # For MVP this is always NO
          FreeTextAnswer.new(:application_details, c100.application_details),
        ].select(&:show?)
      end
    end
  end
end
