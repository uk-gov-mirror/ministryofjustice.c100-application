module Steps
  module AbuseConcerns
    class QuestionForm < BaseForm
      attribute :subject, String
      attribute :kind, String
      attribute :answer, String

      def self.choices
        GenericYesNo.values.map(&:to_s)
      end
      validates_inclusion_of :answer, in: choices

      # This ensures no tampering with the values
      validates_inclusion_of :subject, in: AbuseSubject.values.map(&:to_s)
      validates_inclusion_of :kind,    in: AbuseType.values.map(&:to_s)

      # As this form object is reused permuting `subject` and `kind`, sharing the
      # same view, this key will allow us to render the appropriate translations.
      def i18n_key
        [subject, kind].join('.')
      end

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.abuse_concerns.find_or_initialize_by(
          subject: AbuseSubject.new(subject),
          kind: AbuseType.new(kind),
        ).update(
          answer: GenericYesNo.new(answer)
        )
      end
    end
  end
end
