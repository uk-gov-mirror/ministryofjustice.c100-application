module Summary
  module Sections
    class ChildrenDetails < BaseSectionPresenter
      def name
        :children_details
      end

      def answers
        [
          *children_personal_details,
          Answer.new(:children_known_to_authorities, c100.children_known_to_authorities),
          FreeTextAnswer.new(:children_known_to_authorities_details, c100.children_known_to_authorities_details),
          Answer.new(:children_protection_plan, c100.children_protection_plan),
        ].select(&:show?)
      end

      private

      # rubocop:disable Metrics/AbcSize
      def children_personal_details
        c100.children.map do |child|
          [
            FreeTextAnswer.new(:child_full_name, child.full_name),
            DateAnswer.new(:child_dob, child.dob),
            FreeTextAnswer.new(:child_age_estimate, child.age_estimate), # This shows only if a value is present
            Answer.new(:child_sex, child.gender),
            MultiAnswer.new(:child_applicants_relationship, relation_to_child(child, c100.applicants)),
            MultiAnswer.new(:child_respondents_relationship, relation_to_child(child, c100.respondents)),
            MultiAnswer.new(:child_orders, child.child_order&.orders),
          ]
        end.flatten
      end
      # rubocop:enable Metrics/AbcSize

      def relation_to_child(child, people)
        child.relationships.where(person: people).pluck(:relation)
      end
    end
  end
end
