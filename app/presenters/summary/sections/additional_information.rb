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
          Answer.new(:language_assistance,           language_assistance_value,          default: default_value),
        ]
      end

      private

      def arrangement
        @_arrangement ||= c100.court_arrangement
      end

      def urgent_or_without_notice_value
        [
          c100.urgent_hearing,
          c100.without_notice,
        ].detect { |answer| answer.eql?(GenericYesNo::YES.to_s) }
      end

      def international_or_capacity_value
        [
          c100.international_resident,
          c100.international_jurisdiction,
          c100.international_request,
          c100.reduced_litigation_capacity,
        ].detect { |answer| answer.eql?(GenericYesNo::YES.to_s) }
      end

      # TODO: maintain for a while until all applications are using the new table
      def language_assistance_value
        return c100.language_help if arrangement.nil?

        return GenericYesNo::YES if [
          arrangement.language_interpreter,
          arrangement.sign_language_interpreter,
        ].any?

        default_value
      end

      def default_value
        GenericYesNo::NO
      end
    end
  end
end
