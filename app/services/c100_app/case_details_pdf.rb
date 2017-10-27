module C100App
  class CaseDetailsPdf
    attr_reader :c100_application, :controller_ctx, :presenter, :pdf

    PDF_CONFIG = {
      formats: [:pdf],
      pdf: true,
      encoding: 'UTF-8'
    }.freeze

    def initialize(c100_application, controller_ctx, presenter)
      @c100_application = c100_application
      @controller_ctx = controller_ctx
      @presenter = presenter
    end

    def generate
      @pdf = controller_ctx.render_to_string(render_options)
    end

    def filename
      presenter.pdf_filename + '.pdf'
    end

    private

    def render_options
      PDF_CONFIG.merge(template: controller_ctx.pdf_template)
    end
  end
end
