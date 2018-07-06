module Steps
  module AbuseConcerns
    class DetailsForm < BaseAbuseForm
      attribute :behaviour_description, String
      attribute :behaviour_start, String
      attribute :behaviour_ongoing, YesNo
      attribute :behaviour_stop, String
      attribute :asked_for_help, YesNo
      attribute :help_party, String
      attribute :help_provided, YesNo
      attribute :help_description, String

      private

      def persist!
        super(attributes_map)
      end
    end
  end
end
