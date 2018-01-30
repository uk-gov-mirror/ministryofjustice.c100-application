module Summary
  module Sections
    class MiamRequirement < BaseSectionPresenter
      def name
        :miam_requirement
      end

      def show_header?
        false
      end

      def answers
        [
          Answer.new(:miam_child_protection,     c100.child_protection_cases),
          Answer.new(:miam_exemption_claimed,    default_value), # TODO: pending finish exemptions
          Answer.new(:miam_certificate_received, c100.miam_certification),
          Answer.new(:miam_attended,             c100.miam_attended),
        ].select(&:show?)
      end

      private

      def default_value
        GenericYesNo::NO
      end
    end
  end
end
