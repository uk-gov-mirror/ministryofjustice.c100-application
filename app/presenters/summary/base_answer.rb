module Summary
  class BaseAnswer
    attr_reader :question, :value, :change_path

    def initialize(question, value, change_path: nil)
      @question = question
      @value = value
      @change_path = change_path
    end

    def show?
      value?
    end

    def value?
      value.present?
    end

    def show_change_link?
      change_path.present?
    end

    # Used by Rails to determine which partial to render
    # :nocov:
    def to_partial_path
      raise 'implement in subclasses'
    end
    # :nocov:
  end
end
