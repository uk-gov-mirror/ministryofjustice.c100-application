module C100App
  class ApplicationDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :without_notice
        after_without_notice
      when :without_notice_details
        edit(:without_notice) # TODO: change when we have international steps
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_without_notice
      if question(:without_notice).yes?
        edit(:without_notice_details)
      else
        edit(:without_notice)
      end
    end
  end
end
