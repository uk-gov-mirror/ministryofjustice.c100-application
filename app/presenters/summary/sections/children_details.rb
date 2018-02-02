module Summary
  module Sections
    class ChildrenDetails < BaseChildrenDetails
      def name
        :children_details
      end

      def answers
        [
          children_details,
          Answer.new(:children_known_to_authorities, c100.children_known_to_authorities),
          FreeTextAnswer.new(:children_known_to_authorities_details, c100.children_known_to_authorities_details),
          Answer.new(:children_protection_plan, c100.children_protection_plan),
        ].flatten.select(&:show?)
      end

      private

      def children_details
        children.map.with_index(1) do |child, index|
          [
            Separator.new(:child_index_title, index: index),
            personal_details(child),
            relationships(child),
            MultiAnswer.new(:child_orders, child.child_order&.orders)
          ]
        end
      end

      def children
        @_children ||= c100.children
      end
    end
  end
end
