module Summary
  module HtmlSections
    class ChildrenDetails < Summary::HtmlSections::BaseChildrenDetails
      def name
        :children_details
      end

      def answers
        [
          children_details,
          Answer.new(:has_other_children,
                     c100.has_other_children,
                     change_path: edit_steps_children_has_other_children_path),
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
                            change_path: edit_steps_children_orders_path(child.id)),
          ]
        end
      end

      def edit_children_names_path
        '/steps/children/names'
      end

      def edit_child_details_path(child, field_stub)
        edit_steps_children_personal_details_path(
          child.id,
          anchor: anchor(field_stub)
        )
      end

      def anchor(field_stub)
        format(
          "steps_children_personal_details_form_%<field_stub>s",
          field_stub: field_stub
        )
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
