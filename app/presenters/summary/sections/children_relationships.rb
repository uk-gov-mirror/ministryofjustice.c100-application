module Summary
  module Sections
    class ChildrenRelationships < BaseSectionPresenter
      def name
        :children_relationships
      end

      def answers
        [
          FreeTextAnswer.new(
            :applicants_relationships,
            RelationshipsPresenter.new(c100_application).relationship_to_children(c100.applicants)
          ),
          FreeTextAnswer.new(
            :respondents_relationships,
            RelationshipsPresenter.new(c100_application).relationship_to_children(c100.respondents)
          ),
          FreeTextAnswer.new(
            :other_parties_relationships,
            RelationshipsPresenter.new(c100_application).relationship_to_children(c100.other_parties)
          ),
        ].select(&:show?)
      end
    end
  end
end
