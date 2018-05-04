module Summary
  module HtmlSections
    class ChildrenFurtherInformation < Sections::BaseSectionPresenter
      def name
        :children_further_information
      end

      def answers
        [
          Answer.new(
            :children_known_to_authorities,
            c100.children_known_to_authorities,
            change_path: edit_steps_children_additional_details_path
          ),
          FreeTextAnswer.new(
            :children_known_to_authorities_details,
            c100.children_known_to_authorities_details,
            change_path: edit_steps_children_additional_details_path
          ),
          Answer.new(
            :children_protection_plan,
            c100.children_protection_plan,
            change_path: edit_steps_children_additional_details_path
          ),
        ].select(&:show?)
      end
    end
  end
end
