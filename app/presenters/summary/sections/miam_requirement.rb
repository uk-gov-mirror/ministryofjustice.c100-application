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
          Partial.new(:miam_information),
          Answer.new(:miam_child_protection,     c100.child_protection_cases, default: default_value),
          Answer.new(:miam_exemption_claim,      c100.miam_exemption_claim,   default: default_value),
          Answer.new(:miam_certificate_received, c100.miam_certification,     default: default_value),
          Answer.new(:miam_attended,             c100.miam_attended,          default: default_value),
        ].select(&:show?)
      end

      private

      def default_value
        GenericYesNo::NO
      end
    end
  end
end
