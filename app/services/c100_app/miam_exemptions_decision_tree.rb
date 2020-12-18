module C100App
  class MiamExemptionsDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :domestic
        edit(:protection)
      when :protection
        edit(:urgency)
      when :urgency
        edit(:adr)
      when :adr
        edit(:misc)
      when :misc
        after_miam_exemption_misc
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    def playback_destination
      if miam_not_required? || has_mediator_details?
        edit('/steps/petition/orders')
      elsif has_miam_exemptions?
        show('/steps/miam_exemptions/reasons_playback')
      elsif has_safety_concerns?
        show('/steps/miam_exemptions/safety_playback')
      else
        show('/steps/miam_exemptions/exit_page')
      end
    end

    private

    def has_miam_exemptions?
      MiamExemptionsPresenter.new(
        c100_application.miam_exemption
      ).exemptions.any?
    end

    def after_miam_exemption_misc
      if has_miam_exemptions?
        show('/steps/safety_questions/start')
      else
        show('/steps/miam_exemptions/exit_page')
      end
    end

    def has_safety_concerns?
      c100_application.has_safety_concerns?
    end

    def has_mediator_details?
      c100_application.miam_certification_number?
    end

    def miam_not_required?
      c100_application.consent_order? || c100_application.child_protection_cases?
    end
  end
end
