module Summary
  class Partial
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def show?
      true
    end

    def to_partial_path
      "steps/completion/shared/#{name}"
    end
  end
end
