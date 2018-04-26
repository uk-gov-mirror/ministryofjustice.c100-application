module Summary
  module HtmlSections
    class ChildrenDetails < Summary::HtmlSections::BaseChildrenDetails
      def name
        :children_details
      end

      def answers
        [
          children_details,
          Answer.new(:children_known_to_authorities,
                     c100.children_known_to_authorities,
                     change_path: edit_steps_children_additional_details_path),
          FreeTextAnswer.new(:children_known_to_authorities_details,
                             c100.children_known_to_authorities_details,
                             change_path: edit_steps_children_additional_details_path),
          Answer.new(:children_protection_plan,
                     c100.children_protection_plan,
                     change_path: edit_steps_children_additional_details_path),
        ].flatten.select(&:show?)
      end

      private

      def children_details
        children.map.with_index(1) do |child, index|
          [
            Separator.new(:child_index_title, index: index),
            personal_details(child),
            relationships(child),
            MultiAnswer.new(:child_orders,
                            order_types(child),
                            change_path: edit_steps_children_orders_path(child)),
          ]
        end
      end

      def order_types(child)
        child.child_order&.orders.to_a.map do |o|
          PetitionOrder.type_for(o)
        end.uniq
      end

      def children
        @_children ||= c100.children
      end
    end
  end
end
