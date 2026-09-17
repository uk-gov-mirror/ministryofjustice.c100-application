module C100App
  class NavigationStack
    CYA_FUNNEL = %w[
      /steps/application/payment
      /steps/application/check_your_answers
    ].freeze

    FAST_FORWARD_STEPS = [
      %r{^/steps/abuse_concerns/details.*},
      %r{^/steps/abuse_concerns/contact$},
      %r{^/steps/petition/protection$},
      %r{^/steps/.+/privacy_known.*},
      %r{^/steps/.+/privacy_preferences.*},
      %r{^/steps/.+/personal_details.*},
      %r{^/steps/.+/address_details.*},
      %r{^/steps/.+/contact_details.*},
      %r{^/steps/children/additional_details$},
      %r{^/steps/application/court_proceedings$},
      %r{^/steps/application/.*details$},
      %r{^/steps/attending_court/.+},
    ].freeze

    FAST_FORWARD_REGEXP = Regexp.union(FAST_FORWARD_STEPS).freeze

    def initialize(paths)
      @paths = paths
    end

    def updated_for(current_path)
      return @paths if fast_forward_to_cya?(current_path)

      stack_until_current_page = @paths.take_while do |path|
        !path.eql?(current_path)
      end

      stack_until_current_page + [current_path]
    end

    def previous_path
      @paths.slice(-2)
    end

    def progressed?
      @paths.size > 2
    end

    def fast_forward_to_cya?(current_path)
      cya_origin? && FAST_FORWARD_REGEXP.match?(current_path)
    end

    private

    def cya_origin?
      CYA_FUNNEL.eql?(@paths.last(CYA_FUNNEL.size))
    end
  end
end
