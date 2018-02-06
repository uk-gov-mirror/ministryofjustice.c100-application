module Summary
  module Sections
    class SolicitorDetails < BaseSectionPresenter
      def name
        :solicitor_details
      end

      def show_header?
        false
      end

      def answers
        [
          Answer.new(:has_solicitor, GenericYesNo::NO), # Always `NO` for pilot (we are screening)
        ].select(&:show?)
      end
    end
  end
end
