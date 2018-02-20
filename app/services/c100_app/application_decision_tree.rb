module C100App
  class ApplicationDecisionTree < BaseDecisionTree
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
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
        edit(:help_paying)
      when :help_paying
        show('/steps/completion/summary') # TODO: change when we have 'statement of truth'
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

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
  end
end
