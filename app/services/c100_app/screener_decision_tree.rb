module C100App
  class ScreenerDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :children_postcodes
        check_if_court_is_valid
      when :urgency
        after_urgency
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
        edit(:urgency)
      end

    # CourtPostcodeChecker already logs the exception
    rescue StandardError
      show(:error_but_continue)
    end

    def after_urgency
      if question(:urgent, c100_application.screener_answers).yes?
        show(:urgent_exit)
      else
        edit('/steps/miam/consent_order')
      end
    end
  end
end
