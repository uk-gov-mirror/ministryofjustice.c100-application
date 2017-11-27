module C100App
  class MiamDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :miam_acknowledgement
        edit(:attended)
      when :miam_attended
        after_miam_attended
      when :miam_certification
        after_miam_certification
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_miam_attended
      if question(:miam_attended).yes?
        edit(:certification)
      else
        show(:not_attended_info)
      end
    end

    def after_miam_certification
      if question(:miam_certification).yes?
        # edit(:certification_details)
        # TODO: waiting for now until this step is more solid
        edit('/steps/applicant/number_of_children')
      else
        show(:no_certification_kickout)
      end
    end
  end
end