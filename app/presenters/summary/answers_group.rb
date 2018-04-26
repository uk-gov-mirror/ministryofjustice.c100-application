module Summary
  class AnswersGroup
    attr_reader :name, :answers, :change_path, :name_args

    def initialize(name, answers, params = {})
      @name = name
      @answers = answers
      @change_path = params[:change_path]
      @name_args = params[:name_args]
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
