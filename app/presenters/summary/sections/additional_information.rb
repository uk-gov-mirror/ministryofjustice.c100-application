module Summary
  module Sections
    class AdditionalInformation < BaseSectionPresenter
      def name
        :additional_information
      end

      def answers
        [
          Answer.new(:asking_for_permission,         default_value), # Always NO, as we are screening out people
          Answer.new(:urgent_or_without_notice,      urgent_or_without_notice_value,     default: default_value),
          Answer.new(:children_previous_proceedings, c100.children_previous_proceedings, default: default_value),
          Answer.new(:consent_order,                 c100.consent_order,                 default: default_value),
          Answer.new(:international_or_capacity,     international_or_capacity_value,    default: default_value),
          Answer.new(:language_assistance,           default_value), # TODO: this step is still missing
        ]
      end

      private

      def urgent_or_without_notice_value
        # TODO: to be decided when `urgent` apply
        c100.without_notice
      end

      def international_or_capacity_value
        [
          c100.international_resident,
          c100.international_jurisdiction,
          c100.international_request,
          c100.reduced_litigation_capacity,
        ].detect { |answer| answer.eql?(GenericYesNo::YES.to_s) }
      end

      def default_value
        GenericYesNo::NO
      end
    end
  end
end
