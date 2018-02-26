module Summary
  module Sections
    class C1aBaseAbuseSummary < BaseSectionPresenter
      attr_reader :verbose

      def initialize(c100_application, verbose: false)
        @verbose = verbose
        super(c100_application)
      end

      def answers
        return details_of_abuse if verbose

        [
          Answer.new(:c1a_abuse_physical,      answer_for(AbuseType::PHYSICAL)),
          Answer.new(:c1a_abuse_emotional,     answer_for(AbuseType::EMOTIONAL)),
          Answer.new(:c1a_abuse_psychological, answer_for(AbuseType::PSYCHOLOGICAL)),
          Answer.new(:c1a_abuse_sexual,        answer_for(AbuseType::SEXUAL)),
          Answer.new(:c1a_abuse_financial,     answer_for(AbuseType::FINANCIAL)),
        ]
      end

      private

      def details_of_abuse
        abuses_suffered.each do |abuse|
          [
            Answer.new(:c1a_abuse_type, abuse.kind),
          ]
        end.flatten
      end

      def answer_for(kind)
        c100.abuse_concerns.find_by(
          subject: subject,
          kind: kind,
        )&.answer || default_value
      end

      def abuses_suffered
        c100.abuse_concerns.where(
          answer: GenericYesNo::YES,
          subject: subject,
        )
      end

      def default_value
        GenericYesNo::NO
      end
    end
  end
end
