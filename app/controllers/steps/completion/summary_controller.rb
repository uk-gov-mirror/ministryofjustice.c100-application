module Steps
  module Completion
    class SummaryController < Steps::CompletionStepController
      def show
        respond_to do |format|
          format.html do
            @presenter = Summary::HtmlPresenter.new(current_c100_application)
          end

          format.pdf do
            presenter = Summary::PdfPresenter.new(current_c100_application)
            presenter.generate

            # If we want to trigger a file download, instead of showing the PDF
            # in the browser, we can use `send_data presenter.to_pdf`
            render plain: presenter.to_pdf
          end
        end
      end
    end
  end
end
