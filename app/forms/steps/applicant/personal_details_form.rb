module Steps
  module Applicant
    class PersonalDetailsForm < BaseForm
      # TODO: Add more attributes or change type if necessary
      attribute :personal_details, String

      # TODO: Delete this method and add different validation if you don't have a value object
      def self.choices
        PersonalDetails.values.map(&:to_s)
      end
      validates_inclusion_of :personal_details, in: choices

      private

      # TODO: Delete this method if you don't have a value object
      def personal_details_value
        PersonalDetails.new(personal_details)
      end

      # TODO: Change this method if you don't have a single value object
      def changed?
        !c100_application.personal_details.eql?(personal_details_value)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application
        return true unless changed?

        # TODO: Update this to persist your form object if you don't have a single value object
        c100_application.update(
          personal_details: personal_details_value
          # The following are dependent attributes that need to be reset
          # TODO: Are there any dependent attributes? Reset them here.
        )
      end
    end
  end
end
