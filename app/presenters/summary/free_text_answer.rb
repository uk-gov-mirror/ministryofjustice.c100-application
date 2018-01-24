module Summary
  class FreeTextAnswer < BaseAnswer
    def to_partial_path
      'shared/free_text_row'
    end

    def show?
      true
    end
  end
end
