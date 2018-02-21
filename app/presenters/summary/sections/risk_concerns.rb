module Summary
  module Sections
    class RiskConcerns < BaseSectionPresenter
      def name
        :risk_concerns
      end

      def to_partial_path
        'steps/completion/shared/risk_concerns'
      end

      def answers
        [
          Answer.new(:domestic_abuse,     c100.domestic_abuse,    default: default_value),
          Answer.new(:children_abduction, c100.risk_of_abduction, default: default_value),
          Answer.new(:children_abuse,     c100.children_abuse,    default: default_value),
          Answer.new(:substance_abuse,    c100.substance_abuse,   default: default_value),
          Answer.new(:other_concerns,     c100.other_abuse,       default: default_value),
        ]
      end

      def any?
        c100.has_safety_concerns?
      end

      private

      def default_value
        GenericYesNo::NO
      end
    end
  end
end
