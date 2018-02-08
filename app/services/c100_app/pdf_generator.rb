module C100App
  class PdfGenerator
    delegate :to_pdf, to: :combiner

    def generate(presenter, copies:)
      doc = pdf_from_presenter(presenter)

      copies.times do
        combiner << CombinePDF.parse(doc)
      end
    end

    private

    def pdf_from_presenter(presenter)
      WickedPdf.new.pdf_from_string(render(presenter), pdf_options)
    end

    def render(presenter)
      ApplicationController.render(
        template: presenter.template,
        locals: { presenter: presenter }
      )
    end

    def combiner
      @_combiner ||= CombinePDF.new
    end

    def pdf_options
      { footer: { right: '[page]/[topage]' } }
    end
  end
end
