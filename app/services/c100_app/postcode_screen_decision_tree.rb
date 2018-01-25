module C100App
  class PostcodeScreenDecisionTree < BaseDecisionTree
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
      courts = CourtPostcodeChecker.new.courts_for(c100_application.children_postcodes)
      if courts.empty?
        show(:no_court_found)
      else
        edit('/steps/miam/consent_order')
      end

    # CourtPostcodeChecker already logs the exception
    rescue
      show(:error_but_continue)
    end
  end
end
