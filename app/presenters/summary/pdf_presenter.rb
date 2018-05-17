module Summary
  class PdfPresenter
    attr_reader :c100_application
    attr_reader :pdf_generator

    delegate :to_pdf, to: :pdf_generator

    def initialize(c100_application, generator = C100App::PdfGenerator.new)
      @c100_application = c100_application
      @pdf_generator = generator
    end

    def generate
      generate_c100_form
      generate_c1a_form
      generate_c8_form
    end

    def filename
      'C100 child arrangements application.pdf'.freeze
    end

    private

    def generate_c100_form
      pdf_generator.generate(
        Summary::C100Form.new(c100_application), copies: 1
      )
    end

    def generate_c1a_form
      return unless c100_application.has_safety_concerns?

      pdf_generator.generate(
        Summary::C1aForm.new(c100_application), copies: 1
      )
    end

    def generate_c8_form
      return unless c100_application.confidentiality_enabled?

      pdf_generator.generate(
        Summary::BlankPage.new(c100_application), copies: 1
      )
      pdf_generator.generate(
        Summary::C8Form.new(c100_application), copies: 1
      )
    end
  end
end
