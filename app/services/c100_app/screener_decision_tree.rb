module C100App
  class ScreenerDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :children_postcodes
        check_if_court_is_valid
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def check_if_court_is_valid
      courts = CourtPostcodeChecker.new.courts_for(step_params.fetch(:children_postcodes))

      if courts.empty?
        show(:no_court_found)
      else
        court = Court.build(courts.first)
        c100_application.screener_answers.update!(local_court: court)
        show(:done)
      end
    # `CourtPostcodeChecker` and `Court` already log any potential exceptions
    rescue StandardError
      show(:error_but_continue)
    end
  end
end
