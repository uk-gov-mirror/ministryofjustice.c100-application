module C100App
  class OpeningDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :children_postcode
        check_if_court_is_valid
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def children_postcode
      step_params.fetch(:children_postcode)
    end

    def check_if_court_is_valid
      court = CourtPostcodeChecker.new.court_for(children_postcode)

      if court
        c100_application.update!(court: court)
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
