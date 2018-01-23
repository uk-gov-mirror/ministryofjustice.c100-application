module Summary
  class HtmlPresenter
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def sections
      [
        Sections::ExampleSection.new(c100_application),
      ].select(&:show?)
    end
  end
end
