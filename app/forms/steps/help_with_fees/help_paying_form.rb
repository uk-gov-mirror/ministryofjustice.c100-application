module Steps
  module HelpWithFees
    class HelpPayingForm < BaseForm
      attribute :help_paying, String

      def self.choices
        HelpPaying.values.map(&:to_s)
      end
      validates_inclusion_of :help_paying, in: choices

      private

      def help_paying_value
        HelpPaying.new(help_paying)
      end

      def changed?
        !c100_application.help_paying.eql?(help_paying_value)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application
        return true unless changed?

        c100_application.update(
          help_paying: help_paying_value
          # The following are dependent attributes that need to be reset
          # TODO: Are there any dependent attributes? Reset them here.
        )
      end
    end
  end
end
