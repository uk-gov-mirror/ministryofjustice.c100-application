module Steps
  module Application
    class DeclarationForm < BaseForm
      attribute :declaration_signee, StrippedString
      attribute :declaration_signee_capacity, String

      validates_presence_of  :declaration_signee
      validates_inclusion_of :declaration_signee_capacity, in: UserType.string_values

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          declaration_signee: declaration_signee,
          declaration_signee_capacity: declaration_signee_capacity,
        )
      end
    end
  end
end
