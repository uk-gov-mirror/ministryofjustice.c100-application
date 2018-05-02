module Summary
  module HtmlSections
    class OtherChildrenDetails < Summary::HtmlSections::BaseChildrenDetails
      def name
        :other_children_details
      end

      def answers
        return [Separator.not_applicable] if other_children.empty?

        [
          other_children_details
        ].flatten.select(&:show?)
      end

      private

      def other_children_details
        other_children.map.with_index(1) do |child, index|
          [
            Separator.new(:other_child_index_title, index: index),
            personal_details(child),
            relationships(child),
          ]
        end
      end

      def edit_children_names_path
        '/steps/other_children/names'
      end

      def edit_child_details_path(child, field_stub)
        edit_steps_other_children_personal_details_path(
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

      def other_children
        @_other_children ||= c100.other_children
      end
    end
  end
end
