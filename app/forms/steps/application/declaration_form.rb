module Steps
  module Application
    class DeclarationForm < BaseForm
      attribute :declaration_made, Boolean

      validates_presence_of :declaration_made

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          declaration_made: declaration_made
        )
      end
    end
  end
end
