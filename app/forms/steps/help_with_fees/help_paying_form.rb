module Steps
  module HelpWithFees
    class HelpPayingForm < BaseForm
      attribute :help_paying, String
      attribute :hwf_reference_number, String

      def self.choices
        HelpPaying.values.map(&:to_s)
      end

      validates_inclusion_of :help_paying, in: choices
      validates_presence_of  :hwf_reference_number, if: :reference_number_needed?

      private

      def reference_number_needed?
        help_paying.eql?(HelpPaying::YES_WITH_REF_NUMBER.to_s)
      end

      def help_paying_value
        HelpPaying.new(help_paying)
      end

      def changed?
        !c100_application.help_paying.eql?(help_paying_value) ||
          !c100_application.hwf_reference_number.eql?(hwf_reference_number)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application
        return true unless changed?

        c100_application.update(
          help_paying: help_paying_value,
          hwf_reference_number: hwf_reference_number
          # The following are dependent attributes that need to be reset
          # TODO: Are there any dependent attributes? Reset them here.
        )
      end
    end
  end
end
