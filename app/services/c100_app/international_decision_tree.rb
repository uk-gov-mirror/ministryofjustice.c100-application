module C100App
  class InternationalDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :resident
        edit(:jurisdiction)
      when :jurisdiction
        edit(:request)
      when :request
        # TODO: add here MIAM exemptions steps when they are finished
        edit('/steps/application/details')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
