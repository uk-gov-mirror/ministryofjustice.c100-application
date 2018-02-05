module Steps
  module Shared
    class RelationshipForm < BaseForm
      attribute :relation, String
      attribute :relation_other_value, String

      def self.choices
        Relation.string_values
      end
      validates_inclusion_of :relation, in: choices

      validates_presence_of :relation_other_value, if: :other_value_needed?

      private

      def relation_value
        Relation.new(relation)
      end

      def other_value
        relation_other_value if other_value_needed?
      end

      def other_value_needed?
        relation.eql?(Relation::OTHER.to_s)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record.update(
          relation: relation_value,
          relation_other_value: other_value
        )
      end
    end
  end
end
