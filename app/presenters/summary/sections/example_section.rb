module Summary
  module Sections
    class ExampleSection < SectionPresenter
      def name
        :example_section
      end

      # Typically, a section will be composed of several questions-answers, and not only
      # one like in this example, but this is to get up and running all the neccessary setup
      def answers
        [
          Answer.new(:consent_order, c100.consent_order, change_path: edit_steps_miam_consent_order_path),
        ].select(&:show?)
      end
    end
  end
end
