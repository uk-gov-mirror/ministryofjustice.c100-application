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
        show('/steps/safety_questions/start')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    def playback_destination
      if has_miam_exemptions?
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

    def has_safety_concerns?
      SafetyConcernsPresenter.new(
        c100_application
      ).concerns.any?
    end
  end
end
