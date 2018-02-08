module Summary
  class BasePdfForm
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def template
      'steps/completion/summary/show.pdf'
    end

    # :nocov:
    def sections
      raise 'implement in subclasses'
    end
    # :nocov:
  end
end
