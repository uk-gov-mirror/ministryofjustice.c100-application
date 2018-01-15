module C100App
  class ApplicationDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :without_notice
        after_without_notice
      when :without_notice_details
        start_international_journey
      when :litigation_capacity
        after_litigation_capacity
      when :litigation_capacity_details
        start_international_journey # TODO: change when we have special assistance step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

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
        start_international_journey # TODO: change when we have special assistance step
      end
    end

    def start_international_journey
      edit('/steps/international/resident')
    end
  end
end
