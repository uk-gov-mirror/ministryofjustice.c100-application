module Steps
  module Applicant
    class UserTypeForm < BaseForm
      attribute :user_type, String

      def self.choices
        UserType.string_values
      end
      validates_inclusion_of :user_type, in: choices

      private

      def user_type_value
        UserType.new(user_type)
      end

      def changed?
        !c100_application.user_type.eql?(user_type_value)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application
        return true unless changed?

        c100_application.update(
          user_type: user_type_value
          # The following are dependent attributes that need to be reset
          # TODO: Are there any dependent attributes? Reset them here.
        )
      end
    end
  end
end
