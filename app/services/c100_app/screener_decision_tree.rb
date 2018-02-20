module C100App
  class ScreenerDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :children_postcodes
        check_if_court_is_valid
      when :urgency
        after_urgency
      when :parent
        after_parent
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
        # store the first court in session so that if they choose "yes, it's urgent"
        # we can render the court's contact details out to them in the next step
        court = Court.new.from_courtfinder_data!(courts.first)
        c100_application.screener_answers.update!(local_court: court)
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
        edit(:parent)
      end
    end

    def after_parent
      if question(:parent, c100_application.screener_answers).yes?
        edit('/steps/miam/consent_order')
      else
        show(:parent_exit)
      end
    end
  end
end
