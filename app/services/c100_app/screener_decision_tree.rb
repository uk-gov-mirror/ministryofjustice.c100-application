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
      when :over18
        after_over18
      when :legal_representation
        after_legal_representation
      when :written_agreement
        after_written_agreement
      when :email_consent
        start_application_journey
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
        edit(:over18)
      else
        show(:parent_exit)
      end
    end

    def after_over18
      if question(:over18, c100_application.screener_answers).yes?
        edit(:legal_representation)
      else
        show(:over18_exit)
      end
    end

    def after_legal_representation
      if question(:legal_representation, c100_application.screener_answers).no?
        edit(:written_agreement)
      else
        show(:legal_representation_exit)
      end
    end

    def after_written_agreement
      if question(:written_agreement, c100_application.screener_answers).no?
        edit(:email_consent)
      else
        show(:written_agreement_exit)
      end
    end

    # This is the very first step of the C100 application, once the screener
    # has been successfully completed and the user is eligible.
    #
    # We might need to change it, but for now using this one. Whatever is the first
    # step, make sure their controller includes the concern `SavepointStep`.
    #
    def start_application_journey
      edit('/steps/miam/consent_order')
    end
  end
end
