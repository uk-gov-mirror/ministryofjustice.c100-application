module Summary
  module HtmlSections
    class ApplicationReasons < Sections::BaseSectionPresenter
      def name
        :application_reasons
      end

      def answers
        [
          FreeTextAnswer.new(
            :application_details,
            c100.application_details,
            change_path: edit_steps_application_details_path
          ),
        ].select(&:show?)
      end
    end
  end
end
