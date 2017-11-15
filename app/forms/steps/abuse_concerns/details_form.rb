module Steps
  module AbuseConcerns
    class DetailsForm < BaseAbuseForm
      attribute :behaviour_description, String
      attribute :behaviour_start, String
      attribute :behaviour_ongoing, String
      attribute :behaviour_stop, String
      attribute :asked_for_help, String
      attribute :help_party, String
      # attribute :help_provided, String
      # attribute :help_description, String

      validates_inclusion_of :behaviour_ongoing, in: GenericYesNo.string_values
      validates_inclusion_of :asked_for_help,    in: GenericYesNo.string_values
      # validates_inclusion_of :help_provided,    in: GenericYesNo.string_values, if: :asked_for_help?

      validates_presence_of :behaviour_description
      validates_presence_of :behaviour_start
      validates_presence_of :behaviour_stop, unless: :behaviour_ongoing?

      validates_presence_of :help_party, if: :asked_for_help?
      # validates_presence_of :help_description, if: :asked_for_help?

      private

      def behaviour_ongoing?
        behaviour_ongoing.eql?(GenericYesNo::YES.to_s)
      end

      def asked_for_help?
        asked_for_help.eql?(GenericYesNo::YES.to_s)
      end

      # This is an optional reveal question so we can't assume we always get a value
      # def help_provided_value
      #   help_provided ? GenericYesNo.new(help_provided) : nil
      # end

      def persist!
        super(
          behaviour_description: behaviour_description,
          behaviour_start: behaviour_start,
          behaviour_ongoing: GenericYesNo.new(behaviour_ongoing),
          behaviour_stop: behaviour_stop,
          asked_for_help: GenericYesNo.new(asked_for_help),
          help_party: help_party,
          # help_provided: help_provided_value,
          # help_description: help_description
        )
      end
    end
  end
end
