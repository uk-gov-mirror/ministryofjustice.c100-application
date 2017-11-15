module Steps
  module AbuseConcerns
    class BaseAbuseStepController < Steps::AbuseConcernsStepController
      private

      def subject_value
        AbuseSubject.new(params.fetch(:subject, AbuseSubject::APPLICANT.to_s))
      end

      def kind_value
        AbuseType.new(params.fetch(:kind, AbuseType::SUBSTANCES.to_s))
      end

      def current_concern
        @_current_concern ||= current_c100_application.abuse_concerns.find_or_initialize_by(
          subject: subject_value,
          kind: kind_value
        )
      end
    end
  end
end
