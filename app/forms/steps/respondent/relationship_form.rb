module Steps
  module Respondent
    class RelationshipForm < BaseForm
      # TODO: Add more attributes or change type if necessary
      attribute :relationship, String

      # TODO: Delete this method and add different validation if you don't have a value object
      def self.choices
        Relationship.string_values
      end
      validates_inclusion_of :relationship, in: choices

      private

      # TODO: Delete this method if you don't have a value object
      def relationship_value
        Relationship.new(relationship)
      end

      # TODO: Change this method if you don't have a single value object
      def changed?
        !c100_application.relationship.eql?(relationship_value)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application
        return true unless changed?

        # TODO: Update this to persist your form object if you don't have a single value object
        c100_application.update(
          relationship: relationship_value
          # The following are dependent attributes that need to be reset
          # TODO: Are there any dependent attributes? Reset them here.
        )
      end
    end
  end
end
