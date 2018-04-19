module Summary
  module HtmlSections
    class ChildProtectionCases < Sections::BaseSectionPresenter
      def name
        :child_protection_cases
      end

      def answers
        [
          Answer.new(
            :child_protection_cases,
            c100.child_protection_cases,
            change_path: edit_steps_miam_child_protection_cases_path
          ),
        ].select(&:show?)
      end
    end
  end
end
