module Summary
  module Sections
    class UrgentHearing < BaseSectionPresenter
      def name
        :urgent_hearing
      end

      def answers
        [
          # TODO: we don't have the urgent steps yet (but for MVP we might do screening)
          Answer.new(:urgent_hearing_details, GenericYesNo::NO),
        ].select(&:show?)
      end
    end
  end
end
