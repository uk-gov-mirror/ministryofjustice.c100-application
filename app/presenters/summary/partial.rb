module Summary
  class Partial
    attr_reader :name

    def initialize(name)
      @name = name
    end

    class << self
      def page_break
        new(:page_break)
      end

      def row_blank_space
        new(:row_blank_space)
      end
    end

    def show?
      true
    end

    def to_partial_path
      "steps/completion/shared/#{name}"
    end
  end
end
