module C100App
  class ApplicationDecisionTree < BaseDecisionTree
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
    def destination
      return next_step if next_step

      case step_name
      when :previous_proceedings
        after_previous_proceedings
      when :court_proceedings
        edit(:urgent_hearing)
      when :urgent_hearing
        after_urgent_hearing
      when :urgent_hearing_details
        edit(:without_notice)
      when :without_notice
        after_without_notice
      when :without_notice_details
        start_international_journey
      when :application_details
        edit(:litigation_capacity)
      when :litigation_capacity
        after_litigation_capacity
      when :litigation_capacity_details
        intermediary_step_for_version
      when :intermediary
        edit(:language)
      when :language
        edit(:special_arrangements)
      when :special_arrangements
        edit(:special_assistance)
      when :special_assistance
        edit(:payment)
      when :payment
        edit(:submission)
      when :submission
        after_submission_type
      when :declaration
        after_declaration
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
        edit(:urgent_hearing)
      end
    end

    def after_urgent_hearing
      if question(:urgent_hearing).yes?
        edit(:urgent_hearing_details)
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
        intermediary_step_for_version
      end
    end

    def after_submission_type
      if c100_application.receipt_email.present?
        show(:receipt_email_check)
      else
        edit(:check_your_answers)
      end
    end

    def after_declaration
      if c100_application.online_submission?
        OnlineSubmissionQueue.new(c100_application).process
        show('/steps/completion/confirmation')
      else
        show('/steps/completion/what_next')
      end
    end

    def start_international_journey
      edit('/steps/international/resident')
    end

    # TODO: leave this until all applications are migrated to version >= 5
    def intermediary_step_for_version
      if c100_application.version >= 5
        edit('/steps/attending_court/intermediary')
      else
        edit(:intermediary)
      end
    end
  end
end
