module Summary
  module Sections
    class C1aSolicitorDetails < BaseSectionPresenter
      def name
        :c1a_solicitor_details
      end

      def answers
        [
          Answer.new(:c1a_has_solicitor, GenericYesNo::NO), # Always `NO` for pilot (we are screening)
        ]
      end
    end
  end
end
