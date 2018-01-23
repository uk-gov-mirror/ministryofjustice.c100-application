module Steps
  module Completion
    class SummaryController < Steps::CompletionStepController
      def show
        respond_to do |format|
          format.html do
            @presenter = Summary::HtmlPresenter.new(current_c100_application)
          end

          format.pdf do
            @presenter = Summary::PdfPresenter.new(current_c100_application)
            render @presenter.pdf_params
          end
        end
      end
    end
  end
end
