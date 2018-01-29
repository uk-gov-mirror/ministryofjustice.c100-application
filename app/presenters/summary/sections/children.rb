module Summary
  module Sections
    class Children < BaseSectionPresenter
      def name
        :children
      end

      # rubocop:disable Metrics/AbcSize
      def answers
        c100.children.map do |child|
          [
            FreeTextAnswer.new(:child_full_name, child.full_name),
            FreeTextAnswer.new(:child_dob, child.dob),
            FreeTextAnswer.new(:child_age_estimate, child.age_estimate), # This shows only if a value is present
            Answer.new(:child_sex, child.gender),
            MultiAnswer.new(:child_applicants_relationship, relation_to_child(child, c100.applicants)),
            MultiAnswer.new(:child_respondents_relationship, relation_to_child(child, c100.respondents)),
            MultiAnswer.new(:child_orders, child.child_order&.orders),
          ]
        end.flatten.select(&:show?)
      end
      # rubocop:enable Metrics/AbcSize

      private

      def relation_to_child(child, people)
        child.relationships.where(person: people).pluck(:relation)
      end
    end
  end
end
