module C100App
  class MiamDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :miam_acknowledgement
        edit(:attended)
      when :miam_attended
        after_miam_attended
      when :miam_exemption_claim
        after_miam_exemption_claim
      when :miam_certification
        after_miam_certification
      when :miam_certification_date
        after_miam_certification_date
      when :miam_certification_details
        after_miam_certification_details
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_miam_exemption_claim
      if question(:miam_exemption_claim).yes?
        edit('/steps/miam_exemptions/domestic')
      else
        show('/steps/safety_questions/start')
      end
    end

    def after_miam_attended
      if question(:miam_attended).yes?
        edit(:certification)
      else
        edit(:exemption_claim)
      end
    end

    def after_miam_certification
      if question(:miam_certification).yes?
        edit(:certification_date)
      else
        edit(:exemption_claim)
      end
    end

    def after_miam_certification_date
      if certification_expired?
        show(:certification_expired_info)
      else
        edit(:certification_details)
      end
    end

    def after_miam_certification_details
      show(:certification_confirmation)
    end

    def certification_expired?
      c100_application.miam_certification_date < 4.months.ago.to_date
    end
  end
end
