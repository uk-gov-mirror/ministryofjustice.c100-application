module Steps
  module AbuseConcerns
    class QuestionForm < BaseAbuseForm
      attribute :answer, String

      def self.choices
        GenericYesNo.string_values
      end
      validates_inclusion_of :answer, in: choices

      private

      def answer_value
        GenericYesNo.new(answer)
      end

      def persist!
        abuse_attributes = { answer: answer_value }

        # The following are dependent attributes that need to be reset
        abuse_attributes.merge!(
          behaviour_description: nil,
          behaviour_start: nil,
          behaviour_ongoing: nil,
          behaviour_stop: nil,
          asked_for_help: nil,
          help_party: nil,
          help_provided: nil,
          help_description: nil
        ) if answer_value.eql?(GenericYesNo::NO)

        super(abuse_attributes)
      end
    end
  end
end
