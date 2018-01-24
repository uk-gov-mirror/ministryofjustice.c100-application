module Summary
  class HtmlPresenter
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def sections
      [] # If we were to have a check your answers page, add here the sections
    end
  end
end
