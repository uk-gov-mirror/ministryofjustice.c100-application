module C100App
  class PdfGenerator
    delegate :to_pdf, to: :combiner

    def generate(presenter, copies:)
      main_doc = pdf_from_presenter(presenter)
      raw_file = presenter.raw_file_path

      copies.times do
        combiner << CombinePDF.parse(main_doc)
        combiner << CombinePDF.load(raw_file) if raw_file
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
