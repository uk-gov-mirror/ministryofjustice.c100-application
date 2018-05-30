module C100App
  class ApplicationDecisionTree < BaseDecisionTree
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
    def destination
      return next_step if next_step

      case step_name
      when :previous_proceedings
        after_previous_proceedings
      when :court_proceedings
        edit(:without_notice)
      when :without_notice
        after_without_notice
      when :without_notice_details
        start_international_journey
      when :application_details
        edit(:language)
      when :language
        edit(:litigation_capacity)
      when :litigation_capacity
        after_litigation_capacity
      when :litigation_capacity_details
        edit(:intermediary)
      when :intermediary
        edit(:special_assistance)
      when :special_assistance
        edit(:special_arrangements)
      when :special_arrangements
        help_paying_or_payment
      when :payment
        edit(:submission)
      when :help_paying
        edit(:check_your_answers)
      when :print_and_post_submission
        show('/steps/completion/what_next')
      when :online_submission
        show('/steps/completion/confirmation')
      when :submission
        after_submission
      when :declaration
        show('/steps/completion/what_next')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity

    private

    def after_previous_proceedings
      if question(:children_previous_proceedings).yes?
        edit(:court_proceedings)
      else
        edit(:without_notice)
      end
    end

    def after_without_notice
      if question(:without_notice).yes?
        edit(:without_notice_details)
      else
        start_international_journey
      end
    end

    def after_litigation_capacity
      if question(:reduced_litigation_capacity).yes?
        edit(:litigation_capacity_details)
      else
        edit(:intermediary)
      end
    end

    def start_international_journey
      edit('/steps/international/resident')
    end

    # TODO: temporary journey for user testing on staging
    def help_paying_or_payment
      if dev_tools_enabled?
        edit(:payment)
      else
        edit(:help_paying)
      end
    end

    def after_submission
      case c100_application.submission_type
      when SubmissionType::ONLINE.to_s
        send_emails(c100_application)
        show('/steps/completion/online_submission')
      else
        show('/steps/completion/what_next')
      end
    end

    def send_emails(c100)
      # TODO: switch to perform_later
      SendApplicationToCourtJob.perform_now(
        c100,
        to: c100.court_from_screener_answers.email
      )
    end
  end
end
