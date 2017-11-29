module C100App
  class MiamDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :miam_acknowledgement
        edit(:attended)
      when :miam_attended
        after_miam_attended
      when :miam_certification_date
        after_miam_certification_date
      when :miam_certification
        after_miam_certification
      when :miam_certification_number
        after_miam_certification_number
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_miam_attended
      if question(:miam_attended).yes?
        edit(:certification_date)
      else
        show(:not_attended_info)
      end
    end

    def after_miam_certification_date
      if certification_expired?
        show(:certification_expired_kickout)
      else
        edit(:certification)
      end
    end

    def after_miam_certification
      if question(:miam_certification).yes?
        edit(:certification_number)
      else
        show(:no_certification_kickout)
      end
    end

    def after_miam_certification_number
      # TODO: eventually, we will call an external mediators API to check whether the
      # reference number is valid or not, and retrieve the mediator details.
      show('/steps/safety_questions/start')
    end

    def certification_expired?
      c100_application.miam_certification_date < 4.months.ago.to_date
    end
  end
end
