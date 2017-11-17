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

      validates_inclusion_of :behaviour_ongoing, in: GenericYesNo.values
      validates_inclusion_of :asked_for_help,    in: GenericYesNo.values
      validates_inclusion_of :help_provided,     in: GenericYesNo.values, if: -> { asked_for_help&.yes? }

      validates_presence_of :behaviour_description
      validates_presence_of :behaviour_start
      validates_presence_of :behaviour_stop, if: -> { behaviour_ongoing&.no? }

      validates_presence_of :help_party,
                            :help_description, if: -> { asked_for_help&.yes? }

      private

      def persist!
        super(attributes_map)
      end
    end
  end
end
