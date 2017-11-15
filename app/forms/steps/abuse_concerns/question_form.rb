module Steps
  module AbuseConcerns
    class QuestionForm < BaseAbuseForm
      attribute :answer, String

      def self.choices
        GenericYesNo.values.map(&:to_s)
      end
      validates_inclusion_of :answer, in: choices

      private

      def persist!
        super(
          answer: GenericYesNo.new(answer)
        )
      end
    end
  end
end
