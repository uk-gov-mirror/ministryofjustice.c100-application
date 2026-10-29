module C100App
  class OpeningDecisionTree < BaseDecisionTree
    # rubocop:disable Metrics/MethodLength
    def destination
      return next_step if next_step

      case step_name
      when :children_postcode
        check_if_court_is_valid
      when :start_or_continue
        after_start_or_continue
      when :sign_in_or_create_account
        after_sign_in_or_create_account
      when :continue_application
        after_continue_application
      when :research_consent
        after_research_consent
      when :my_hmcts
        after_my_hmcts
      when :consent_order
        after_consent_order
      when :consent_order_upload
        show(:consent_order_sought)
      when :child_protection_cases
        after_child_protection_cases
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
    # rubocop:enable all

    private

    def children_postcode
      c100_application.children_postcode
    end

    def check_if_my_hmcts_eligable_court
      # if eligable_court
      #   edit(:my_hmcts)
      # else
      edit(:consent_order)
      # end
    end

    # Temp
    def check_if_court_is_valid
      puts 'here'
      court = CourtPostcodeChecker.new.court_for(children_postcode)
      puts 'court:' + court.inspect

      if court
        c100_application.update!(court:)

        if show_research_consent?
          edit(:research_consent)
        else
          check_if_my_hmcts_eligable_court
        end
      else
        show(:no_court_found)
      end
      # `CourtPostcodeChecker` and `Court` already log any potential exceptions
    rescue StandardError
      show(:error_but_continue)
    end

    def after_my_hmcts
      edit(:consent_order)
    end

    def after_sign_in_or_create_account
      if question(:has_myhmcts_account).yes?
        show(:my_hmcts_manage_case)
      else
        show(:my_hmcts_create_account)
      end
    end

    def after_continue_application
      if question(:platform, c100_application, ApplicationPlatform).my_hmcts?
        show(:my_hmcts_manage_case)
      else
        show(:redirect_to_login)
      end
    end

    def after_start_or_continue
      if question(:start_or_continue, c100_application, ApplicationIntent).new?
        after_start
      else
        after_continue
      end
    end

    def after_start
      if question(:is_legal_representative).yes?
        check_court_and_send_to_court_based_destination
      else
        check_court_and_send_to_court_based_destination_for_citizens
      end
    end

    def after_continue
      check_court_and_send_to_court_based_destination_for_continue
    end

    def after_research_consent
      if question(:is_legal_representative).yes?
        send_to_court_based_destination(skip_research_consent: true)
      else
        send_to_court_based_destination_for_citizens(skip_research_consent: true)
      end
    end

    def check_court_and_send_to_court_based_destination
      court = CourtPostcodeChecker.new.court_for(children_postcode)

      return show(:no_court_found) unless court
      c100_application.update!(court:)

      send_to_court_based_destination
    # `CourtPostcodeChecker` and `Court` already log any potential exceptions
    rescue StandardError
      show(:error_but_continue)
    end

    def check_court_and_send_to_court_based_destination_for_citizens
      court = CourtPostcodeChecker.new.court_for(children_postcode)

      return show(:no_court_found) unless court
      c100_application.update!(court:)

      send_to_court_based_destination_for_citizens
    # `CourtPostcodeChecker` and `Court` already log any potential exceptions
    rescue StandardError
      show(:error_but_continue)
    end

    def check_court_and_send_to_court_based_destination_for_continue
      court = CourtPostcodeChecker.new.court_for(children_postcode)
      return show(:no_court_found) unless court
      c100_application.update!(court:)

      send_to_court_based_destination_for_continue
    # `CourtPostcodeChecker` and `Court` already log any potential exceptions
    rescue StandardError
      show(:error_but_continue)
    end

    def send_to_court_based_destination(skip_research_consent: false)
      if show_research_consent? && !skip_research_consent
        edit(:research_consent)
      elsif eligable_court
        edit(:sign_in_or_create_account)
      else
        show(:start)
      end
    end

    def send_to_court_based_destination_for_continue
      if eligable_court
        if question(:is_legal_representative).yes?
          edit(:continue_application)
        else
          show(:redirect_to_guidance)
        end
      else
        show(:redirect_to_login)
      end
    end

    def send_to_court_based_destination_for_citizens(
      skip_research_consent: false
    )
      if show_research_consent? && !skip_research_consent
        edit(:research_consent)
      elsif eligable_court
        show(:redirect_to_guidance)
      else
        show(:start)
      end
    end

    def after_consent_order
      if question(:consent_order).yes?
        edit(:consent_order_upload)
      else
        edit(:child_protection_cases)
      end
    end

    def after_child_protection_cases
      # If we know is a consent order, then it does not matter the answer
      # to this question, we bypass MIAM (jump to safety questions)
      return show('/steps/safety_questions/start') if question(:consent_order).yes?

      if question(:child_protection_cases).yes?
        show(:child_protection_info)
      else
        edit('/steps/miam/acknowledgement')
      end
    end

    def show_research_consent?
      ResearchSampler.candidate?(
        c100_application, Rails.configuration.x.opening.research_consent_weight
      )
    end

    def eligable_court
      c100_application.court.id.in? %w[
        swansea-civil-justice-centre
        kingston-upon-hull-combined-court-centre
        great-grimsby-combined-court-centre
        wolverhampton-combined-court-centre
        chelmsford-county-and-family-court
        chelmsford-magistrates-court-and-family-court
      ]
    end
  end
end
