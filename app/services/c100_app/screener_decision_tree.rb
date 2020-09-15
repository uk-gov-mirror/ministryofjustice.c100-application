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

    # TODO: rename param to be singular, not plural, when removing the screener
    def children_postcode
      step_params.fetch(:children_postcodes)
    end

    def check_if_court_is_valid
      court_found = CourtPostcodeChecker.new.court_for(children_postcode)

      if court_found
        court = Court.build(court_found)
        c100_application.screener_answers.update!(local_court: court)
        show(:done)
      else
        show(:no_court_found)
      end
    # `CourtPostcodeChecker` and `Court` already log any potential exceptions
    rescue StandardError
      show(:error_but_continue)
    end
  end
end
