module Summary
  class PdfPresenter
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def sections
      [
        Sections::ExampleSection.new(c100_application),
      ].select(&:show?)
    end

    def pdf_params
      { pdf: pdf_filename, footer: { right: '[page]' } }
    end

    private

    def pdf_filename
      'c100_application'.freeze # TODO: to be decided
    end
  end
end