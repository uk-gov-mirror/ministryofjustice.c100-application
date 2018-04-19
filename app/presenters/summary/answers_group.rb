module Summary
  class AnswersGroup
    attr_reader :name, :answers, :change_path

    def initialize(name, answers, change_path: nil)
      @name = name
      @answers = answers
      @change_path = change_path
    end

    def show?
      answers.any?(&:show?)
    end

    def show_change_link?
      change_path.present?
    end

    def to_partial_path
      'steps/completion/shared/answers_group'
    end
  end
end
