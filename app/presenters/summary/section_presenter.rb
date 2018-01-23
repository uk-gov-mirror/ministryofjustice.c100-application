module Summary
  class SectionPresenter
    include Rails.application.routes.url_helpers

    attr_reader :c100_application
    alias_attribute :c100, :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    # Used by Rails to determine which partial to render
    def to_partial_path
      'shared/section'
    end

    # May be overridden in subclasses to hide/show if appropriate
    def show?
      answers.any?
    end

    protected

    # :nocov:
    def answers
      raise 'must be implemented in subclasses'
    end
    # :nocov:
  end
end
