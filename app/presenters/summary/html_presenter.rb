module Summary
  class HtmlPresenter
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def sections
      [
        HtmlSections::ChildProtectionCases.new(c100_application),
        HtmlSections::MiamRequirement.new(c100_application),
        HtmlSections::MiamExemptions.new(c100_application),
        HtmlSections::NatureOfApplication.new(c100_application),
        HtmlSections::Alternatives.new(c100_application),
      ].flatten.select(&:show?)
    end
  end
end
