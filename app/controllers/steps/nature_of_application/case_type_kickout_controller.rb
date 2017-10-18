module Steps::NatureOfApplication
  class CaseTypeKickoutController < Steps::NatureOfApplicationStepController
    def show
      @c100_application = current_c100_application
    end
  end
end
