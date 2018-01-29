module Summary
  module Sections
    class ChildrenRelationships < BaseSectionPresenter
      def name
        :children_relationships
      end

      def answers
        [
          FreeTextAnswer.new(:applicants_relationships,    relationships_with(c100.applicants)),
          FreeTextAnswer.new(:respondents_relationships,   relationships_with(c100.respondents)),
          FreeTextAnswer.new(:other_parties_relationships, relationships_with(c100.other_parties)),
          FreeTextAnswer.new(:children_residence,          children_residence)
        ].select(&:show?)
      end

      private

      def children
        @_children ||= c100.children
      end

      def children_residence
        ChildResidence.where(child: children).map do |residence|
          residence_full_names(residence)
        end.join('; ')
      end

      def relationships_with(people)
        c100.relationships.where(child: children, person: people).map do |relationship|
          [
            relationship.person.full_name,
            i18n_relation(relationship),
            relationship.child.full_name
          ].join(' - ')
        end.join('; ')
      end

      def i18n_relation(relationship)
        return relationship.relation_other_value if relationship.relation.eql?(Relation::OTHER.to_s)
        t(relationship.relation, scope: 'dictionary.RELATIONS')
      end

      # TODO: we might need to separate which child lives with each of the parties
      # For now it is not clear in the PDF mockup, so this is just a simple solution.
      # :nocov:
      def residence_full_names(residence)
        names = c100.people.where(id: residence.person_ids).pluck(:full_name)
        names << residence.other_full_name if residence.other?
        names
      end
      # :nocov:
    end
  end
end
