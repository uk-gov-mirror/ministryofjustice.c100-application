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

            # render plain: presenter.to_pdf
            send_data(presenter.to_pdf, filename: presenter.filename)
          end
        end
      end
    end
  end
end
