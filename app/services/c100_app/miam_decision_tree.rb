module C100App
  class MiamDecisionTree < BaseDecisionTree
    # rubocop:disable Metrics/MethodLength
    def destination
      return next_step if next_step

      case step_name
      when :consent_order
        after_consent_order
      when :child_protection_cases
        after_child_protection_cases
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
    # rubocop:enable Metrics/MethodLength

    private

    def after_consent_order
      if question(:consent_order).yes?
        show(:consent_order_sought)
      else
        edit(:child_protection_cases)
      end
    end

    def after_child_protection_cases
      if question(:child_protection_cases).yes?
        show(:child_protection_info)
      else
        edit(:acknowledgement)
      end
    end

    def after_miam_exemption_claim
      if question(:miam_exemption_claim).yes?
        start_miam_exemptions_journey
      else
        start_safety_questions_journey
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
      # TODO: eventually, we will call an external mediators API to check whether the
      # reference number is valid or not, and retrieve the mediator details.
      show(:certification_confirmation)
    end

    def certification_expired?
      c100_application.miam_certification_date < 4.months.ago.to_date
    end

    def start_miam_exemptions_journey
      edit('/steps/miam_exemptions/domestic')
    end

    def start_safety_questions_journey
      show('/steps/safety_questions/start')
    end
  end
end
