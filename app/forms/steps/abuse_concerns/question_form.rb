module Steps
  module AbuseConcerns
    class QuestionForm < BaseAbuseForm
      attribute :answer, YesNo

      validates_inclusion_of :answer, in: GenericYesNo.values

      private

      def persist!
        abuse_attributes = { answer: answer }

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
        ) if answer.no?

        super(abuse_attributes)
      end
    end
  end
end
