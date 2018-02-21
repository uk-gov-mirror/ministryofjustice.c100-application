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
      pdf_generator.generate(c100_form, copies: 3)
      pdf_generator.generate(c1a_form,  copies: 3) if c100_application.has_safety_concerns?
      pdf_generator.generate(c8_form,   copies: 1) if c100_application.confidentiality_enabled?
    end

    private

    def c100_form
      Summary::C100Form.new(c100_application)
    end

    def c1a_form
      Summary::C1aForm.new(c100_application)
    end

    def c8_form
      Summary::C8Form.new(c100_application)
    end

    def cover_letter
      # TODO
    end
  end
end
