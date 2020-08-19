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
        after_request_step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    # TODO: check the permission rules here to decide if we go to
    # `application/permission_sought` or to `application/details`
    #
    def after_request_step
      edit('/steps/application/permission_sought')
    end
  end
end
