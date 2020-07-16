module C100App
  class ScreenerDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :children_postcodes
        check_if_court_is_valid
      when :parent
        after_parent
      when :email_consent
        show(:done)
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
        court = Court.new(courts.first)
        c100_application.screener_answers.update!(local_court: court)
        edit(:parent)
      end

    # `CourtPostcodeChecker` and `Court` already log any potential exceptions
    rescue StandardError
      show(:error_but_continue)
    end

    def after_parent
      return show(:parent_exit) if question(:parent, c100_application.screener_answers).no?

      if Rails.configuration.x.screener.show_email_consent_step
        edit(:email_consent)
      else
        show(:done)
      end
    end
  end
end
